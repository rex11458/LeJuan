//
//  PYHistoryRecord.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/18.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYHistoryRecord.h"
#import <objc/runtime.h>
@implementation PYHistoryRecord

- (instancetype)initWithTaskType:(PYTaskType)taskType searchType:(NSInteger)searchType searchKey:(NSString *)searchKey
{
    if (self = [super init]) {
        
        self.taskType = taskType;
        self.searchType = searchType;
        self.searchKey = searchKey;
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([PYHistoryRecord class], &count);
    for (int i = 0; i<count; i++){// 取出i位置对应的成员变量
        Ivar ivar = ivars[i];

        // 查看成员变量
        const char *name = ivar_getName(ivar);// 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([PYHistoryRecord class], &count);
        for (int i = 0; i < count; i++) {
            
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}


/*!
 *  判断两个record 是否相同
 */

- (BOOL)isEqualRecord:(PYHistoryRecord *)record
{
    return (self.taskType == record.taskType && self.searchType == record.searchType && [self.searchKey isEqualToString:record.searchKey]);
}

@end
