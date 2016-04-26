//
//  PYTaskHanlder.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseHandler.h"
#import "PYTask.h"
#import "PYHistoryRecord.h"
@interface PYTaskHanlder : BaseHandler

/*
 *获取问卷列表
 */
+ (NSURLSessionDataTask *)getTaskListWithUserLoginId:(NSInteger)userLoginId type:(PYTaskType)type pageIndex:(NSInteger)pageIndex success:(SuccessBlock)success failure:(FailureBlock)failure;

/*
 *下载问卷
 */

+ (NSURLSessionDataTask *)downloadTask:(NSString *)paperId resultId:(NSString *)resultId success:(SuccessBlock)success failure:(FailureBlock)failure;

/*!
 *  更新是否下载状态
 *
 *  @param resultId   <#resultId description#>
 *  @param isDownload <#isDownload description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)updateDownloadTaskStatus:(NSString *)resultId isDownload:(BOOL)isDownload success:(SuccessBlock)success failure:(FailureBlock)failure;

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
+ (NSURLSessionDataTask *)searchTask:(NSInteger)userLoginId
                           pageIndex:(NSInteger )pageIndex
                              record:(PYHistoryRecord *)record
                             success:(SuccessBlock)success
                              failed:(FailureBlock)failure;

@end
