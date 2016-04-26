//
//  BaseHandler.h
//  lianhebao
//
//  Created by Steven on 14-10-8.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYAppNetWorkClient.h"

@interface BaseHandler : NSObject

//+ (id)sharedHandler;
/**
 *  Handler处理完成后调用的Block
 */
typedef void (^CompleteBlock)();

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailureBlock)(id error_msg);


@end
