//
//  PYUser.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseModel.h"
@class PYManagedUser;
@interface PYUser : BaseModel

@property (nonatomic,assign) NSInteger userLoginId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *password;



//- (PYManagedUser *)ConversionToManagedUser;

@end
