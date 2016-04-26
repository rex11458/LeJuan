//
//  PYUserHandler.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYUserHandler.h"
#import "PYUser.h"
#import "PYJSVersion.h"
#import "PYLoginUserManager.h"
#import "PYQuestionnaireManager.h"
#import <ZipArchive/ZipArchive.h>
#import "PYQuestionnaireManager.h"
#import "PYManagedUser.h"
@implementation PYUserHandler

+ (NSURLSessionDataTask *)loginWithName:(NSString *)name password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *parameters = PYLoginBody([NSString checkString:name],[NSString checkString:password]);

    return [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:PYLoginURL parameters:parameters isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        if (isError)
        {
            failure(error.localizedDescription);
        }else
        {
            PYUser *user = [PYUser mj_objectWithKeyValues:results];
            
            if (user.status)
            {
                [self  saveLoginUserInfo:user name:name password:password];

                success(user);
            }
            else
                failure(user.errorMsg);
        }
    }];
}

#pragma mark - 保存用户登录信息
+ (void)saveLoginUserInfo:(PYUser *)user name:(NSString *)loginName password:(NSString *)password
{
    PYLoginUser *l_user = [[PYLoginUser alloc] init];
   
    l_user.userPassword = password;
    l_user.loginName = loginName;

    l_user.userLoginId = user.userLoginId;
    l_user.username = user.userName;
    l_user.userType = user.userType;

    
    PYManagedUser *usr = [[PYQuestionnaireManager sharedInstance] selectUserWithLoginName:l_user.loginName];
  
    if (usr.userRealname.length != 0 && usr.userPhoneNumber.length != 0) {
        l_user.userRealname = usr.userRealname;
        l_user.userPhoneNumber = usr.userPhoneNumber;
    }
    
    [PYLoginUserManager shareInstance].loginUser = l_user;
    [PYLoginUserManager saveUserLoginInfo];
    
    [[PYQuestionnaireManager sharedInstance] insertUser:l_user];
    
    //创建用户文件沙盒路径
    if (![FCFileManager existsItemAtPath:PYUserQuestionnaireSadboxPath]) {
        [FCFileManager createDirectoriesForPath:PYUserQuestionnaireSadboxPath];
    }
}

#pragma mark - 检查JS更新
+ (NSURLSessionDataTask *)checkJsUpdateSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
   NSURLSessionDataTask *task = [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:PYCheckJsUpdateURL parameters:PYChekJsUpdateBody isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
    
       if (isError)
       {
           if(failure)
               failure(error.localizedDescription);
      
       }else
       {
           PYJSVersion *jsVersion = [PYJSVersion mj_objectWithKeyValues:results];
           
           NSInteger localJsVersion = [PYLoginUserManager shareInstance].jsVersion;
           
           if (jsVersion.version != localJsVersion)
           {
               [self downloadJS:jsVersion];
           }
           
           if (success)
               success(jsVersion);
       }
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)downloadJS:(PYJSVersion *)jsVersion
{
  NSURLSessionDataTask *task = [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:jsVersion.url parameters:nil isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
      
      if (isError) return ;

      dispatch_async(dispatch_get_global_queue(0, 0), ^{
         
          NSString *filePath = [DocumentDir stringByAppendingPathComponent:[PYAssetName stringByAppendingPathExtension:@"zip"]] ;
          BOOL ret = [results writeToFile:filePath atomically:YES];
          
          if (!ret) return;
          //下载成功
          ZipArchive *archive = [[ZipArchive alloc] init];
          if ([archive UnzipOpenFile:filePath])
          {
              NSString *strUnZipPath = PYQuestionnaireRootPath;
              BOOL ret = [archive UnzipFileTo:strUnZipPath overWrite: YES];
           
              if (!ret) return;
              //解压成功
              [archive UnzipCloseFile];
              [FCFileManager removeItemAtPath:filePath];
              [PYLoginUserManager shareInstance].jsVersion = jsVersion.version;
          }
      });
    }];
    
    return task;
}

@end
