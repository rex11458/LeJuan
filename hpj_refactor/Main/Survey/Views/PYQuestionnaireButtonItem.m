//
//  PYQuestionnaireButtonItem.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/4.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYQuestionnaireButtonItem.h"
#import "PYTask.h"

@implementation PYQuestionnaireButtonItem

- (void)setTask:(PYTask *)task
{
    if (task == nil) {
        return;
    }
    _task = task;
    
    self.title = [self itemTitle];
}

- (NSString *)itemTitle
{
    NSString *title = @"进店";
    if (_task.isDeparture) {
        //已离店
        title = @"";
        
    }else if (_task.isArrival){
        //已进店
        title = @"离店";
    }
    
    return title;
}

@end
