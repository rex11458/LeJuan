//
//  UIView+ActivityIndicator.m
//  lianhebao
//
//  Created by LiuRex on 16/3/16.
//  Copyright © 2016年 TouTou. All rights reserved.
//

#import "UIView+ActivityIndicator.h"
static const char ActivityIndicatorViewKey = '\e';

@implementation UIView (ActivityIndicator)

- (void)animationWithStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicator.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,CGRectGetHeight(self.bounds) * 0.5);
    [indicator startAnimating];
    [self addSubview:indicator];
    
    objc_setAssociatedObject(self, &ActivityIndicatorViewKey,
                             indicator, OBJC_ASSOCIATION_RETAIN);
    
    
    self.userInteractionEnabled = NO;

}

- (void)endAnimation
{
    UIActivityIndicatorView *indicator = objc_getAssociatedObject(self, &ActivityIndicatorViewKey);
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    
    self.userInteractionEnabled = YES;
}

@end
