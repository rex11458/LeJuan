//
//  PYUserHandler.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseHandler.h"

@interface PYUserHandler : BaseHandler

+ (NSURLSessionDataTask *)loginWithName:(NSString *)name password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (NSURLSessionDataTask *)checkJsUpdateSuccess:(SuccessBlock)success failure:(FailureBlock)failure;


@end
