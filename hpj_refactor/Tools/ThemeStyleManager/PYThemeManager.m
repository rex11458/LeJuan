//
//  PYThemeManager.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYThemeManager.h"
#import "PYDefaultTheme.h"
@implementation PYThemeManager


+ (void)defaultAppAppearance
{
    id<PYTheme> theme = [PYDefaultTheme defaultTheme];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[theme statusBarStyle]];
  
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.translucent = NO;
    [navigationBar setTitleTextAttributes:[theme navBarTitleStyle]];
    [navigationBar setBackgroundImage:[theme navBarBackground] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTintColor:[theme tintColor]];
}

@end