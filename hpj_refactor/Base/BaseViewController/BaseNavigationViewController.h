//
//  BaseNavigationViewController.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseNavigationViewController;


@interface BaseNavigationViewController : UINavigationController

@end

@interface UINavigationController (PopAction)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;

@end