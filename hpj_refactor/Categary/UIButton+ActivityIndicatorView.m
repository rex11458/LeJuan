//
//  UIButton+ActivityIndicatorView.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/1.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "UIButton+ActivityIndicatorView.h"
static const char ActivityIndicatorViewKey = '\e';
static const char ButtonTitleKey = '\f';
@implementation UIButton (ActivityIndicatorView)

- (void)animationWithStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicator.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,CGRectGetHeight(self.bounds) * 0.5);
    [indicator startAnimating];
    [self addSubview:indicator];
    
    objc_setAssociatedObject(self, &ActivityIndicatorViewKey,
                             indicator, OBJC_ASSOCIATION_ASSIGN);
    
    objc_setAssociatedObject(self, &ButtonTitleKey,
                             self.currentTitle, OBJC_ASSOCIATION_RETAIN);
    
    self.userInteractionEnabled = NO;
    [self setTitle:nil forState:UIControlStateNormal];
}
- (void)endAnimatingWithTitle:(NSString *)title
{
    UIActivityIndicatorView *indicator = objc_getAssociatedObject(self, &ActivityIndicatorViewKey);
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    
    self.userInteractionEnabled = YES;
    if (title == nil) {
        title = objc_getAssociatedObject(self, &ButtonTitleKey);
    }
    [self setTitle:title forState:UIControlStateNormal];
}
@end
