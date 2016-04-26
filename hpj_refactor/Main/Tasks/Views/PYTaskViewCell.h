//
//  PYTaskViewCell.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewCell.h"
#import "RMDownloadIndicator.h"
@class PYTask;
@interface PYTaskViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *storeNoLabel;

@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

- (void)verification:(PYTask *)task;

@end
