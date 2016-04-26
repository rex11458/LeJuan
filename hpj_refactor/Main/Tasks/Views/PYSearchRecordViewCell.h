//
//  PYSearchRecordViewCell.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/18.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewCell.h"
@class PYHistoryRecord;

@protocol PYSearchRecordViewCellDelegate ;

@interface PYSearchRecordViewCell : BaseViewCell
@property (strong, nonatomic) IBOutlet UILabel *s_textLabel;

@property (nonatomic, strong) PYHistoryRecord *record;

@property (nonatomic, weak) id<PYSearchRecordViewCellDelegate> delegate;
- (IBAction)deleteAction:(id)sender;

@end

@protocol PYSearchRecordViewCellDelegate <NSObject>

@optional
- (void)searchRecordViewCell:(PYSearchRecordViewCell *)cell delete:(PYHistoryRecord *)record;

@end
