//
//  PYQuestionProtocol.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/3.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PYQuestionProtocol <NSObject>

@property (nullable, nonatomic, copy) NSString *questionId;
@property (nullable, nonatomic, copy) NSString *answerId;
@property (nullable, nonatomic, copy) NSString *subQuestionId;
@property (nullable, nonatomic, copy) NSString *result;
@property (nullable, nonatomic, copy) NSString *remark;

@end
