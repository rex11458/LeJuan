//
//  PYUndownloadTaskDetailViewController.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"

@class PYTask;
@interface PYUndownloadTaskDetailViewController : BaseViewController

@property (nonatomic, strong) PYTask *task;

@property (nonatomic, copy) SuccessBlock downloadSuccessBlock;

@end
