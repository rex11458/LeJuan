//
//  UIButton+ActivityIndicatorView.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/1.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ActivityIndicatorView)

- (void)animationWithStyle:(UIActivityIndicatorViewStyle)style;

- (void)endAnimatingWithTitle:(NSString *)title;

@end
