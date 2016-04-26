//
//  PYUserProtocol.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PYUserProtocol <NSObject>

@property (nonatomic,assign) NSInteger userLoginId;
@property (nullable, nonatomic, retain) NSString *userType;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *userRealname;
@property (nullable, nonatomic, retain) NSString *userPassword;
@property (nullable, nonatomic, retain) NSString *userCity;
@property (nullable, nonatomic, retain) NSString *userPhoneNumber;
@property (nullable, nonatomic, retain) NSString *loginName;

@end
