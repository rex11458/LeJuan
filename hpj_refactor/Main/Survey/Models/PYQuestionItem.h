//
//  PYQuestionItem.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/6.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  {"qindex":"1","completed":"0","qid":"944_0_2439"}
 */
@interface PYQuestionItem : NSObject

@property (nonatomic, copy) NSString *qid;
@property (nonatomic, copy) NSString *qindex;
@property (nonatomic, assign) BOOL completed;


@end
