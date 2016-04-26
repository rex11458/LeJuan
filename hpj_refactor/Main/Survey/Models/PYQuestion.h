//
//  PYQuestion.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/3.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYQuestion : NSObject<PYQuestionProtocol>

- (BOOL)isImage;

+ (int)imageCountFromArray:(NSArray<PYQuestion *> *)questions;

@end
