//
//  PYImproveTitleView.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYImproveTitleView.h"

@implementation PYImproveTitleView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configSubViews];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame target:(id)target aciton:(SEL)aciton
{
    if (self = [super initWithFrame:frame]) {
        _target = target;
        _aciton = aciton;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,CGRectGetHeight(self.bounds) * 0.5);
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(0, 0, 150, 40);
    _titleButton.center = self.indicatorView.center;
    _titleButton.backgroundColor = [UIColor clearColor];
    [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0];
    [_titleButton setImage:[UIImage imageNamed:@"nav_local"] forState:UIControlStateNormal];
    [_titleButton addTarget:_target action:_aciton forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleButton];
}

- (void)setTitle:(NSString *)title
{
    if (title == nil) {
        return;
    }
    _title = title;
    
    [_titleButton setTitle:title forState:UIControlStateNormal];
}

- (void)startAnimating
{
    [_indicatorView startAnimating];
    _titleButton.hidden = YES;
}
- (void)stopAnimating
{
    [_indicatorView stopAnimating];
    _titleButton.hidden = NO;
    if (self.title.length == 0) {
        [_titleButton setTitle:@"定位失败" forState:UIControlStateNormal];
    }
}
@end
