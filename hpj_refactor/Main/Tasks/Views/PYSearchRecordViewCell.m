//
//  PYSearchRecordViewCell.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/18.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYSearchRecordViewCell.h"
#import "PYHistoryRecord.h"
@implementation PYSearchRecordViewCell

- (void)setRecord:(PYHistoryRecord *)record
{
    if (record == _record || record == nil) {
        return;
    }
    _record = record;
    
    _s_textLabel.text = _record.searchKey;
}

//删除记录
- (IBAction)deleteAction:(id)sender {

    if ([_delegate respondsToSelector:@selector(searchRecordViewCell:delete:)]) {
        [_delegate searchRecordViewCell:self delete:self.record];
    }
}
@end
