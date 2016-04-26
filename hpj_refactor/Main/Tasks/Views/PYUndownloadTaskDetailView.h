//
//  PYUndownloadTaskDetailView.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseView.h"
@class PYTask;
@interface PYUndownloadTaskDetailView : BaseView



@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *downLoadButton;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *provinceLabel;

@property (nonatomic, weak) IBOutlet UILabel *areaLabel;

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIButton *searchMapButton;


@property (nonatomic, weak) IBOutlet UILabel *questionnireNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *questionnireNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *questionnireTypeLabel;

@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;


@property (nonatomic, strong) PYTask *task;


@end
