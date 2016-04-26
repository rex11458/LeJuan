//
//  NSString+Check.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

+ (NSString *)checkString:(NSString *)string
{
    
    if ([string isKindOfClass:[NSNull class]] || string == nil) {
       
        return @"";
    
    }
    
    return string;
}

@end
