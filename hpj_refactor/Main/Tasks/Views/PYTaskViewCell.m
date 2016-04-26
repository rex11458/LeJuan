//
//  PYTaskViewCell.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYTaskViewCell.h"

#define PYCircleWidth 60.0f


@implementation PYTaskViewCell


- (void)verification:(PYTask *)task
{
    if (task.progress == 0)
    {
        _statusLabel.text = @"未填写";
    }
    else if(!task.isDeparture || task.progress != 1)
    {
        _statusLabel.text = @"未验证";
    }else
    {
        _statusLabel.text = @"已验证";
    }
}

@end
