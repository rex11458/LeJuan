//
//  PYTaskHanlder.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYTaskHanlder.h"
#import "PYTask.h"
#import "PYQuestionnaireManager.h"
#import "PYManagedQuestionnaire.h"
@implementation PYTaskHanlder


+ (NSURLSessionDataTask *)getTaskListWithUserLoginId:(NSInteger )userLoginId type:(PYTaskType)type pageIndex:(NSInteger)pageIndex success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:PYTaskListURL parameters:(PYTaskListBody(@(userLoginId),[PYTask downloadType:type],@(pageIndex))) isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        if (isError)
        {
            failure(error.localizedDescription);
        }else
        {
            PYTaskList *taskList = [PYTask taskListWithDictionary:results];
          
            if (taskList.status) {
                success(taskList.list);
            }else{
                failure(taskList.errorMsg);
            }
        }
    }];
}

/*
 *下载问卷
 */

+ (NSURLSessionDataTask *)downloadTask:(NSString *)paperId resultId:(NSString *)resultId success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestGETMethod url:PYDownloadQestionnireURL([paperId checkString],[NSString checkString:resultId],[PYLoginUserManager shareInstance].loginUser.userLoginId ) parameters:nil isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        if (isError)
        {
            failure(error.localizedDescription);
        }else
        {
            
            BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:results];
            
            if (baseModel == nil || baseModel.status)
            {
                [self updateDownloadTaskStatus:resultId isDownload:YES success:^(id obj) {
                    //保存问卷到本地
                    NSString *filePath = PYQuestionnaireSadboxPath(resultId);
                    BOOL ret = [results writeToFile:filePath atomically:YES];

                    if (ret)
                    {
                        success(nil);
                    }
                    else
                    {
                        failure(NSLocalizedString(@"QuestionnaireSavedError", nil));
                    }
                        
                } failure:failure];
                }else
                {
                    failure(baseModel.errorMsg);
                }
        }
    }];
}

/*
 *
 */
+ (NSURLSessionDataTask *)updateDownloadTaskStatus:(NSString *)resultId isDownload:(BOOL)isDownload success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSString checkString:resultId] forKey:varname_to_string(resultId)];
  
    [params setObject:isDownload?@"Y":@"N" forKey:varname_to_string(isDownload)];

    return [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:PYUpdateDownloadStatusURL parameters:params isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        if (isError)
        {
            failure(error.localizedDescription);
        }else
        {
            BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:results];

            if (baseModel.status) {
                success(nil);
            }else{
                failure(baseModel.errorMsg);
            }
        }
    }];
}
/*!
 *  搜索问卷
 *
 *  @param userLoginId <#userLoginId description#>
 *  @param pageIndex   <#pageIndex description#>
 *  @param type        <#type description#>
 *  @param sType       门店名称 或门店编号
 *  @param sKey        <#sKey description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)searchTask:(NSInteger )userLoginId
                           pageIndex:(NSInteger )pageIndex
                              record:(PYHistoryRecord *)record
                             success:(SuccessBlock)success
                              failed:(FailureBlock)failure
{

    PYTaskType type = record.taskType;
    NSInteger sType = record.searchType;
    NSString *sKey = record.searchKey;
    
    //如果搜索的是已下载问卷,直接从数据库获取
    if (type == PYTaskDownloadedType) {
        
       NSSet<PYManagedQuestionnaire *> *questionnaire = [[PYQuestionnaireManager sharedInstance] selectQuestionnaireWithRecord:record relationLoginName:PYCurrentUserLoginName];
//
       NSArray<PYTask *> *tasks = [PYTask conversionFromSet:questionnaire];

        if (tasks.count == 0) {
            failure(@"没有搜索到结果");
        }else{
            success(tasks);
        }
        return nil;
    }
    
    /*
     *通过网络获取
     */
    NSString *searchType = sType ? @"N" : @"C";
    
    NSDictionary *params = @{
                             varname_to_string(userLoginId) : [@(userLoginId) stringValue],
                             varname_to_string(pageIndex)   : [@(pageIndex) stringValue],
                             varname_to_string(type)        : [PYTask downloadType:type],
                             varname_to_string(sType)       : searchType,
                             varname_to_string(sKey)        : [NSString checkString:sKey]
                             
                             };
    
    return [[PYAppNetWorkClient sharedNetWorkClient] py_requstWithMethod:PYRequestPOSTMethod url:PYTaskListURL parameters:params isCache:NO completion:^(id  _Nullable results, NSError * _Nullable error, BOOL isError, BOOL isNetWork) {
        if (isError)
        {
            failure(error.localizedDescription);
        }else
        {
            PYTaskList *taskList = [PYTask taskListWithDictionary:results];

            if (taskList.status) {
                if (taskList.list.count  == 0) {
                    failure(@"没有搜索到结果");
                }else
                {
                    success(taskList.list);
                }
                
            }else{
                failure(taskList.errorMsg);
            }
        }
    }];
}
@end
