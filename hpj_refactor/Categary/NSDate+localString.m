//
//  NSDate+localString.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/5.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "NSDate+localString.h"

@implementation NSDate (localString)

+ (NSString *)localStringDescription
{
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CH"];
    NSString* nowStr = [formatter stringFromDate:now];
    return nowStr;
}

+ (NSDate *)dateWithString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

- (NSString *)yyyy_MM_dd
{
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CH"];
    NSString* nowStr = [formatter stringFromDate:now];
    return nowStr;
}
- (NSString *)HH_mm
{
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CH"];
    NSString* nowStr = [formatter stringFromDate:now];
    return nowStr;
}

@end
