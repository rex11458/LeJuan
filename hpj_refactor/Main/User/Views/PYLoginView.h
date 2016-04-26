//
//  PYLoginView.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseView.h"

@interface PYLoginView : BaseView

@property (nonatomic,weak) IBOutlet UITextField *usernameTxtField;
@property (nonatomic,weak) IBOutlet UITextField *passwordTxtField;
@property (nonatomic,weak) IBOutlet UIButton *loginButton;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;


@end
