//
//  PYSurveyHandler.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/5.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYSurveyHandler.h"
#import "PYImagePath.h"
#import "PYQuestion.h"
#import "Base64.h"
#import "PYTask.h"
@implementation PYSurveyHandler

+ (NSURLSessionDataTask *)uploadQuestionnaire:(PYTask *)task questions:(NSArray<PYQuestion *> *)questions progress:(void(^)(NSProgress *progress,NSString *message))progressBlock success:(SuccessBlock)success failure:(FailureBlock)failure;
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    dispatch_async(queue, ^{
        
        dispatch_group_t uploadGroup = dispatch_group_create();
  
        __block BOOL allImageUploadSuccess = YES;
        __block BOOL currentImageUploadFilished = NO;
        __block int imageCount = 1;
         int totalCount = [PYQuestion imageCountFromArray:questions];

        
        for (PYQuestion *question in questions) {
            BOOL flag = question.isImage;
            
            if (flag) {
                //先上传图片
               
                dispatch_group_enter(uploadGroup);
                
                NSString *imageBase64String = [[FCFileManager readFileAtPathAsData:question.result] base64EncodedString];
                
                 [PYSurveyHandler submitImage:imageBase64String progress:^(NSProgress * progress) {
                    if (progressBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            progressBlock(progress,[NSString stringWithFormat:@"正在上传第%d/%d张图片",imageCount,totalCount]);
                        });
                    }
                } success:^(NSString *imagePath) {
                    imageCount++;
                    question.result = imagePath;
                    dispatch_group_leave(uploadGroup);
                 
                    currentImageUploadFilished = YES;
             
                } failed:^(id error_msg) {
                    allImageUploadSuccess = NO;
                    currentImageUploadFilished = YES;
                    //                    [self cancelAllImageUploadTask:taskArray];
                    failure(@"问卷上传失败");
                    
                    dispatch_group_leave(uploadGroup);

                }];
                
                while (!currentImageUploadFilished) {

                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                currentImageUploadFilished = NO;
            }
            //中止for循环
            if (!allImageUploadSuccess) {
                break;
            }
        }

        //图片全部上传完成后再上传问卷
        dispatch_group_wait(uploadGroup, DISPATCH_TIME_FOREVER);

        dispatch_async(dispatch_get_main_queue(), ^{
            if (allImageUploadSuccess) {
                [self uploadQuestionnaire:task questions:questions success:success failure:failure];
            }
        });
    });
    
    return nil;
}

// 上传图片
+ (NSURLSessionDataTask *)submitImage:(NSString *)imageBase64String progress:(void(^)(NSProgress *))progress success:(SuccessBlock)success failed:(FailureBlock)failed
{
    NSDictionary *params = @{@"imageStream":[NSString checkString:imageBase64String]};
    
    return [[PYAppNetWorkClient sharedNetWorkClient] py_uploadWithMethod:PYRequestPOSTMethod url:PYSubmitImageURL parameters:params progress:progress completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        
        if (isError) {
            failed(error.localizedDescription);
        }else{
            
            PYImagePath *imagePath = [PYImagePath mj_objectWithKeyValues:results];
            
            if (imagePath.status) {
                success(imagePath.imagePath);
                
            }else
            {
                failed(imagePath.errorMsg);
            }
        }
    }];
}

#pragma mark - 提交问卷结果
+ (NSURLSessionDataTask *)uploadQuestionnaire:(PYTask *)task questions:(NSArray *)questions success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    NSDate *arrivalDate = [NSDate dateWithString:task.arrivalTime];
    NSDate *departureDate = [NSDate dateWithString:task.departureTime];
    //问卷完成日期 yyyy-MM-DD
    NSString *resultDate = [departureDate yyyy_MM_dd];
    
    //问卷进店时间 HH-MM
    NSString *startTime = [arrivalDate HH_mm];
    
    //问卷离店时间 HH-MM
    NSString *endTime = [departureDate HH_mm];
    
    //离店坐标
    NSString *addrx = task.addrx;
    NSString *addry = task.addry;
    
    PYLoginUser *usr = [PYLoginUserManager shareInstance].loginUser;
    
    NSDictionary *params = @{
                             @"resultJson"   : [[PYQuestion mj_keyValuesArrayWithObjectArray:questions] mj_JSONString],
                             @"resultId"     :[NSString checkString:task.resultId],
                             @"resultStatus" : @"Y",
                             @"resultDate"   : [NSString checkString:resultDate],
                             @"startDate"    : [NSString checkString:startTime],
                             @"endDate"      : [NSString checkString:endTime],
                             @"addrx"        : [NSString checkString:addrx],
                             @"addry"        : [NSString checkString:addry],
                             //新增三个字段
                             @"visitor"      : [NSString checkString:usr.userRealname],
                             @"mobile"       : [NSString checkString:usr.userPhoneNumber],
                             @"city"         : [NSString checkString:usr.userCity],
                             //新增字段
                             @"leaveRemark"  : [NSString checkString:task.leaveRemark]
                             };
    
    return [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:PYSubmitResultURL parameters:params isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        if (isError)
        {
            failure(error.localizedDescription);
        }
        else
        {
            BaseModel *model = [BaseModel mj_objectWithKeyValues:results];
            if (model.status) {
                success(nil);
            }else{
                failure(model.errorMsg);
            }
        }
    }];
}
//
//#pragma mark - 如果有图片上传失败,则取消所有其它上传的task
//+ (void)cancelAllImageUploadTask:(NSArray *)tasks
//{
//        [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (task.state != NSURLSessionTaskStateCompleted) {
//            [task cancel];
//        }
//        
//    }];
//}
//
//

@end
