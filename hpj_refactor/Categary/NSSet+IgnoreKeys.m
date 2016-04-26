//
//  NSSet+IgnoreKeys.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/3.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "NSSet+IgnoreKeys.h"

@implementation NSSet (IgnoreKeys)



+ (NSArray *)mj_ignoredPropertyNames
{
#warning -- 通过MJExtestion解析NSSet时,忽略这三个字断.
    return @[@"source",@"count",@"relationship"];
}

@end
