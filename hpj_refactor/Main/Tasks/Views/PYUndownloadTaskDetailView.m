//
//  PYUndownloadTaskDetailView.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYUndownloadTaskDetailView.h"

#import "PYTask.h"

@implementation PYUndownloadTaskDetailView

- (void)setTask:(PYTask *)task
{
    if (task == nil || _task == task) {
        return;
    }
    
    _task = task;

    [self fillData];
}


- (void)fillData
{
    _nameLabel.text = _task.prjName;
    _cityLabel.text = [NSString stringWithFormat:@"城市：%@",_task.city];
    _provinceLabel.text = [NSString stringWithFormat:@"省市：%@",_task.province];
    _areaLabel.text = [NSString stringWithFormat:@"区域：%@",_task.area];
    _addressLabel.text = [NSString stringWithFormat:@"地址：%@",_task.addr];
    _questionnireNameLabel.text = [NSString stringWithFormat:@"名称：%@",_task.objName];;
    _questionnireNoLabel.text = [NSString stringWithFormat:@"编号：%@",_task.objCode];
    _questionnireTypeLabel.text = [NSString stringWithFormat:@"类型：%@",_task.paperTitle];
    
    _startDateLabel.text = _task.startDate;
    _endDateLabel.text = _task.endDate;
    
    if (_task.isDownload) {
        [_downLoadButton setTitle:@"去做问卷" forState:UIControlStateNormal];
    }
}

@end
