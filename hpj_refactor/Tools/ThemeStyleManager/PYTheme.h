//
//  PYTheme.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PYTheme <NSObject>

/**
 *  状态栏
 *
 */
- (UIStatusBarStyle)statusBarStyle;

/**
 *  navBar背景图片
 *
 */
- (UIImage *)navBarBackground;

/**
 *  navBar Title字体样式
 *
 */
- (NSDictionary*)navBarTitleStyle;


/**
 *  navBar Tint
 *
 */
- (UIColor *)tintColor;

@optional
/**
 *  tabbar
 *
 */
- (NSDictionary*)tabBarTitleStyle;

- (NSDictionary*)tabBarSelectTitleStyle;


@end