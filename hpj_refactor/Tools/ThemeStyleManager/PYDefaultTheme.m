//
//  PYDefaultTheme.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYDefaultTheme.h"
@implementation PYDefaultTheme

+ (id<PYTheme>)defaultTheme
{
    static id<PYTheme> theme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theme = [[[self class] alloc] init];
    });
    
    return theme;
}



/**
 *  状态栏
 *
 */
- (UIStatusBarStyle)statusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  navBar背景图片
 *
 */
- (UIImage *)navBarBackground
{
    return [UIImage imageWithColor:PYMainColor];
}

/**
 *  navBar Title字体样式
 *
 */
- (NSDictionary*)navBarTitleStyle
{
    UIColor *color = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:20.0f];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,
                          [[NSShadow alloc] init], NSShadowAttributeName,
                          font, NSFontAttributeName, nil];
    return dict;
}


/**
 *  navBar Tint
 *
 */
- (UIColor *)tintColor
{
    return [UIColor whiteColor];
}

@end
