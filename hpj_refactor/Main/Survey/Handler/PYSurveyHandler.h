//
//  PYSurveyHandler.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/5.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseHandler.h"
@class PYQuestion;
@class PYTask;
@interface PYSurveyHandler : BaseHandler

/*!
 *  上传问卷
 *
 *  @param task          <#task description#>
 *  @param questions     <#questions description#>
 *  @param progressBlock <#progressBlock description#>
 *  @param success       <#success description#>
 *  @param failure       <#failure description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)uploadQuestionnaire:(PYTask *)task questions:(NSArray<PYQuestion *> *)questions progress:(void(^)(NSProgress *progress,NSString *message))progressBlock success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (NSURLSessionDataTask *)submitImage:(NSString *)imageBase64String progress:(void(^)(NSProgress *))progress success:(SuccessBlock)success failed:(FailureBlock)failed;

@end
