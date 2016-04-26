//
//  PYLoginView.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYLoginView.h"

@implementation PYLoginView


- (void)awakeFromNib
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFielddidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (NSString *)name
{
    return _usernameTxtField.text;
}

- (void)setName:(NSString *)name
{
    _usernameTxtField.text = name;
}

- (NSString *)password
{
    return _passwordTxtField.text;
}

- (void)setPassword:(NSString *)password
{
    _passwordTxtField.text = password;
}


- (void)textFielddidChange
{
    _loginButton.enabled = (self.name.length != 0 && self.password.length != 0);
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
