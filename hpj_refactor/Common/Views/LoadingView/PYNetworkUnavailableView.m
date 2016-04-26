//
//  PYNetworkUnavailableView.m
//  lianhebao
//
//  Created by lwp on 14-11-13.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import "PYNetworkUnavailableView.h"

@interface PYNetworkUnavailableView ()

@property (nonatomic) UIImageView *imageView; //

@property (nonatomic) UILabel *messageLabel; //


@property (nonatomic) UIButton *reloadButton; //重新加载按钮

@end

@implementation PYNetworkUnavailableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self configSubViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame message:(NSString *)message
{
    if (self = [self initWithFrame:frame]) {
        
        self.message = message;
    }
    return self;
}

- (void)configSubViews
{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_error"]];
    [self addSubview:_imageView];
    
    _messageLabel = [UILabel new];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor =  UIColorFromRGB(0xBABABA);
    _messageLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_messageLabel];
    
    _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reloadButton setTitle:@"点击屏幕,重新加载" forState:UIControlStateNormal];
    [_reloadButton setTitleColor:UIColorFromRGB(0xBABABA)forState:UIControlStateNormal];
    _reloadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    _reloadButton.frame = CGRectMake(0, 0, 200, 40);
    [_reloadButton addTarget:self action:@selector(reloadAcion) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reloadButton];
}

- (void)setMessage:(NSString *)message
{
    if (message == nil) return;
    _message = message;
    _messageLabel.text = message;
}

- (void)reloadAcion
{
    if (_reloadBlock) {
        _reloadBlock();
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self reloadAcion];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _messageLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20);
    _imageView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.3);
    _messageLabel.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,CGRectGetMaxY(_imageView.frame) + CGRectGetHeight(_messageLabel.frame) + 10);
    _reloadButton.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetMaxY(_messageLabel.frame) + CGRectGetHeight(_reloadButton.frame) * 0.5 + 10);
}

@end
