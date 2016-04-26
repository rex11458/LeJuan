//
//  PYLoginUserManager.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYUser.h"
#import "PYHistoryRecord.h"
#import "PYUserProtocol.h"
@class PYManagedUser;
@interface PYLoginUser : NSObject<NSCoding,PYUserProtocol>


@end

@interface PYLoginUserManager : NSObject


@property (nonatomic, assign) NSInteger jsVersion;



@property (nonatomic, strong) PYLoginUser *loginUser;

+ (instancetype)shareInstance;

+ (BOOL)isLogIn;

+ (void)saveUserLoginInfo;
+ (void)saveUserLogoffInfo;

/*!
 *  返回搜索记录
 *
 */
+ (NSArray<PYHistoryRecord *> *)historySearchRecordsWithTaskType:(PYTaskType)taskType searchType:(NSInteger)searchType;

/*!
 *  添加搜索记录
 */
+ (BOOL)addHistorySearchRecord:(PYHistoryRecord *)historyRecord;

/*!
 *  删除搜索记录
 */
+ (BOOL)removeHistorySearchRecord:(PYHistoryRecord *)historyRecord;
/*!
 *  删除所有搜索记录
 */
+ (void)removeAllHistorySearchRecords:(PYTaskType)taskType;

/*!
 *  验证用户是否填写过姓名和手机号
 */
+ (BOOL)verificationRealNameAndPhone;




@end
