//
//  PYImproveInfoView.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYImproveInfoView.h"

@implementation PYImproveInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)becomeFirstResponder
{
    return [_realnameTxtField becomeFirstResponder];
}

- (void)setRealname:(NSString *)realname
{
    _realnameTxtField.text = realname;
}

- (NSString *)realname
{
    return _realnameTxtField.text;
}

- (void)setPhoneNum:(NSString *)phoneNum
{
    _phoneNumTxtField.text = phoneNum;
}

- (NSString *)phoneNum
{
    return _phoneNumTxtField.text;
}


@end
