//
//  PYImproveInfoView.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseView.h"

@interface PYImproveInfoView : BaseView

@property (nonatomic,weak) IBOutlet UITextField *realnameTxtField;
@property (nonatomic,weak) IBOutlet UITextField *phoneNumTxtField;

@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *phoneNum;

@end
