//
//  PYLoginUserManager.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYLoginUserManager.h"
#import "PYManagedUser.h"

static NSString * const PYJsVersionKey = @"JsVersionKey";

@implementation PYLoginUser
@synthesize username;
@synthesize userRealname;
@synthesize userPassword;
@synthesize userPhoneNumber;
@synthesize userType;
@synthesize userCity;
@synthesize loginName;
@synthesize userLoginId;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.userLoginId = [aDecoder decodeIntegerForKey:@"userLoginId"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.userRealname = [aDecoder decodeObjectForKey:@"userRealname"];
        self.userPassword = [aDecoder decodeObjectForKey:@"userPassword"];
        self.userPhoneNumber = [aDecoder decodeObjectForKey:@"userPhoneNumber"];
        self.userType = [aDecoder decodeObjectForKey:@"userType"];
        self.userCity = [aDecoder decodeObjectForKey:@"userCity"];
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeInteger:self.userLoginId forKey:@"userLoginId"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.userRealname forKey:@"userRealname"];
    [aCoder encodeObject:self.userPassword forKey:@"userPassword"];
    [aCoder encodeObject:self.userPhoneNumber forKey:@"userPhoneNumber"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    [aCoder encodeObject:self.userCity forKey:@"userCity"];
}


@end

@implementation PYLoginUserManager
+ (instancetype)shareInstance
{
    static PYLoginUserManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (PYLoginUser *)loginUser
{
    if (_loginUser == nil) {
        _loginUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[PYLoginUserManager userDataArchivePath]];
    }
    return _loginUser;
}

+ (BOOL)isLogIn
{
    BOOL ret = ([NSKeyedUnarchiver unarchiveObjectWithFile:[PYLoginUserManager userDataArchivePath]] != nil);

    if ([PYLoginUserManager shareInstance].loginUser.userPhoneNumber.length == 0) {
        return NO;
    }
    return ret;
}
+ (void)saveUserLoginInfo
{
    NSString *path=[self userDataArchivePath];
    PYLog(@"saveUserInfo====%@",path);
    
    [NSKeyedArchiver archiveRootObject:[PYLoginUserManager shareInstance].loginUser toFile:path];
}
//退出登录
+ (void)saveUserLogoffInfo
{
    [PYLoginUserManager shareInstance].loginUser = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self userDataArchivePath] error:nil];
}

//保存登录后用户数据路径
+ (NSString *)userDataArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"userData.plist"];
}

/*!
 *  搜索记录保存路径
 *
 */
+ (NSString *)userSearchArchivePathWithTaskType:(PYTaskType )type
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"userSearchRecordData_%@.plist",[@(type) stringValue]]];
}


//----JS版本
- (void)setJsVersion:(NSInteger)jsVersion
{
    [[NSUserDefaults standardUserDefaults] setInteger:jsVersion forKey:PYJsVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)jsVersion
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:PYJsVersionKey];
}

/*!
 *  返回搜索记录
 *
 */
+ (NSArray<PYHistoryRecord *> *)historySearchRecordsWithTaskType:(PYTaskType)taskType searchType:(NSInteger)searchType
{
    NSArray<PYHistoryRecord *> *historyRecords = [NSKeyedUnarchiver unarchiveObjectWithFile:[PYLoginUserManager userSearchArchivePathWithTaskType:taskType]];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    
    [historyRecords enumerateObjectsUsingBlock:^(PYHistoryRecord * _Nonnull historyRecord, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (historyRecord.taskType == taskType && historyRecord.searchType == searchType) {
            [mArray addObject:historyRecord];
        }
    }];
    return mArray;
}

/*!
 *  添加搜索记录
 */
+ (BOOL)addHistorySearchRecord:(PYHistoryRecord *)historyRecord
{
    NSMutableArray<PYHistoryRecord *> *historyRecords = [[NSKeyedUnarchiver unarchiveObjectWithFile:[PYLoginUserManager userSearchArchivePathWithTaskType:historyRecord.taskType]] mutableCopy];
    
    if (historyRecords == nil) {
        historyRecords = [NSMutableArray array];
    }
    
    __block BOOL isEixt = NO;
    [historyRecords enumerateObjectsUsingBlock:^(PYHistoryRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([historyRecord isEqualRecord:obj]) {
            isEixt = YES;
            *stop = YES;
        }
    }];
    
    if (!isEixt) {

        [historyRecords addObject:historyRecord];
        
        BOOL ret = [NSKeyedArchiver archiveRootObject:historyRecords toFile:[PYLoginUserManager userSearchArchivePathWithTaskType:historyRecord.taskType]];
        
        
       return ret;

    }else{
        return NO;
    }
}

/*!
 *  删除搜索记录
 */
+ (BOOL)removeHistorySearchRecord:(PYHistoryRecord *)historyRecord
{
    NSMutableArray<PYHistoryRecord *> *historyRecords = [[NSKeyedUnarchiver unarchiveObjectWithFile:[PYLoginUserManager userSearchArchivePathWithTaskType:historyRecord.taskType]] mutableCopy];
  
    if (historyRecords == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [historyRecords enumerateObjectsUsingBlock:^(PYHistoryRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([historyRecord isEqualRecord:obj]) {

            [historyRecords removeObject:obj];
            ret = YES;
            *stop = YES;
        }
    }];
    if (ret) {
        
       return [NSKeyedArchiver archiveRootObject:historyRecords toFile:[PYLoginUserManager userSearchArchivePathWithTaskType:historyRecord.taskType]];
    }else{
        return NO;
    }
}

/*!
 *  删除所有搜索记录
 */
+ (void)removeAllHistorySearchRecords:(PYTaskType)taskType
{
    [[NSFileManager defaultManager] removeItemAtPath:[self userSearchArchivePathWithTaskType:taskType] error:nil];
}

/*!
 *  验证用户是否填写过姓名和手机号
 */
+ (BOOL)verificationRealNameAndPhone
{
    NSString *realName = [PYLoginUserManager shareInstance].loginUser.userRealname;
    NSString *phone = [PYLoginUserManager shareInstance].loginUser.userPhoneNumber;

    return (realName.length != 0 && phone.length != 0);
}

@end
