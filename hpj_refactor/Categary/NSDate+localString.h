//
//  NSDate+localString.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/5.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (localString)

+ (NSString *)localStringDescription;

/*
 * dateString Format : yyyyMMddHHmmss
 */
+ (NSDate *)dateWithString:(NSString *)dateString;

- (NSString *)yyyy_MM_dd;
- (NSString *)HH_mm;

@end
