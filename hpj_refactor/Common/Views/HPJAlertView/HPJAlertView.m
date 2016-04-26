//
//  HPJAlertView.m
//  hpJ
//
//  Created by LiuRex on 15/12/31.
//  Copyright © 2015年 Steven. All rights reserved.
//

#import "HPJAlertView.h"
#define kTitleTextColor   PYMainColor
#define kTitleLabelheight 40.0f
#define kButtonMargin     10.0f
#define kButtonHeight   40.0f
#define HPJAlertViewDefaultHeight 100.0f
@implementation HPJAlertItem

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)color imageName:(NSString *)imageName
{
    if (self = [super init]) {
        self.title = title;
        self.titleColor = color;
        self.imageName = imageName;
        
    }
    return self;
}

@end

@implementation HPJAlertView


- (instancetype)initWithMessage:(NSString *)message Items:(NSArray *)items cancelButtonTitle:(NSString *)title delegate:(id/*HPJAlertViewDelegate*/)delegate
{
    if (self = [self initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, HPJAlertViewDefaultHeight)]) {
        
        [self configSubViews];
        
        self.message = message;
        self.items = items;
        self.cancelButtonTitle = title;
        self.delegate = delegate;
    }
    return self;
}

- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,kTitleLabelheight)];
    _messageLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    _messageLabel.backgroundColor = [UIColor whiteColor];
    _messageLabel.textColor = kTitleTextColor;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
    
    
    //最下面的按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.tag = 0;
    [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    _cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cancelButton.layer.borderWidth = 0.5f;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];

    [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitleColor:kTitleTextColor forState:UIControlStateNormal];

    [self addSubview:_cancelButton];
}

- (void)setMessage:(NSString *)message
{
    if (message != nil && _message != message) {
        _message = message;
        _messageLabel.text = _message;
    }
}

- (void)setItems:(NSArray<HPJAlertItem *> *)items
{
    if (items != nil &&_items != items) {
        _items = [items copy];
    }
    [self addButtons];
}

- (void)addButtons
{
    CGRect frame = self.frame;
    frame.size.height += _items.count * (kButtonMargin + kButtonHeight);
    self.frame = frame;
    
    
    CGFloat startX = CGRectGetWidth(self.bounds) * 0.25;
    CGFloat startY = CGRectGetHeight(self.bounds) - 2 * ( kButtonHeight + kButtonMargin);
    CGFloat buttonWidth =  CGRectGetWidth(self.bounds) * 0.5;
    for (NSInteger i = 0; i < _items.count; i++) {
        
        HPJAlertItem *item = [_items objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(startX,startY - i * (kButtonHeight + kButtonMargin),buttonWidth, kButtonHeight);
        button.tag = i + 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:kTitleTextColor forState:UIControlStateNormal];
        [self addSubview:button];
        
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setTitleColor:item.titleColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
    }
}


- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle
{
    if (cancelButtonTitle != nil && _cancelButtonTitle != cancelButtonTitle) {
        _cancelButtonTitle = cancelButtonTitle;
        [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    }
}

- (void)show
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window addSubview:self];
    self.center = CGPointMake(CGRectGetWidth(self.window.bounds) * 0.5, CGRectGetHeight(self.window.bounds) * 0.5);
    self.window.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.window.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button
{
    [self cancelWithButtonTag:button.tag];
}

- (void)cancelWithButtonTag:(NSInteger)buttonTag
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.0001,0.0001);
        self.window.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _window = nil;
        
        if ([self.delegate respondsToSelector:@selector(alertView:didSelectedIndex:)]) {
            [self.delegate alertView:self didSelectedIndex:buttonTag];
        }
    }];
}

- (void)layoutSubviews
{
    _cancelButton.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.25,CGRectGetHeight(self.bounds) - kButtonHeight - kButtonMargin, CGRectGetWidth(self.bounds) * 0.5, kButtonHeight);
}

@end
