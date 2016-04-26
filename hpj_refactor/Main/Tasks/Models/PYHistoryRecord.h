//
//  PYHistoryRecord.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/18.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYTask.h"
@interface PYHistoryRecord : NSObject<NSCoding>

@property (nonatomic, assign) PYTaskType taskType;
/*!
 *  0 门店编号
 *  1 门店名称
 */
@property (nonatomic, assign) NSInteger searchType;

@property (nonatomic, copy)   NSString *searchKey;

- (instancetype)initWithTaskType:(PYTaskType)taskType searchType:(NSInteger)searchType searchKey:(NSString *)searchKey;

- (BOOL)isEqualRecord:(PYHistoryRecord *)record;


@end
