//
//  PYSurveyViewController.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"

@class PYTask;
@interface PYSurveyViewController : BaseViewController

@property (nonatomic, strong) PYTask *task;


//--
- (void)saveQuestionnaire;
@end
