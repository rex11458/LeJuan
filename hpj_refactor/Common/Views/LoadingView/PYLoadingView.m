//
//  PYLoadingView.m
//  lianhebao
//
//  Created by lwp on 14-11-13.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import "PYLoadingView.h"
#import "PYNetworkUnavailableView.h"
#define Margin 5.0f
@interface PYLoadingView ()
{
    PYNetworkUnavailableView *_networkUnavailableView;
}
@property (nonatomic) UIImageView *logoImageView; //Logo
@property (nonatomic) UIActivityIndicatorView *activityView; //

@end

@implementation PYLoadingView

- (instancetype)initWithTarget:(id)target action:(nullable SEL)action
{
    if (self = [super init]) {
     
        self.target = target;
        self.action = action;
    }
    return self;
}

+ (PYLoadingView *)loadingViewWithTarget:(id)target action:(SEL)action
{
    return [[self alloc] initWithTarget:target action:action];
}

- (void)configSubViews
{
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];

    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];

    }
    if (_logoImageView == nil) {
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_loading"]];
        [self addSubview:_logoImageView];
    }
  }

- (void)show
{
    _loading = YES;
    
    if (_networkUnavailableView) {
        [_networkUnavailableView removeFromSuperview];
    }
    [self configSubViews];
    self.hidden = NO;
    [_activityView startAnimating];
}

- (void)showInView:(UIView *)view
{
    self.frame = view.bounds;
    [view addSubview:self];
    
    [self show];
}

- (void)dismiss
{
    [_activityView stopAnimating];
  
    self.hidden = YES;
    _loading = NO;

}

- (void)showErrorWithMessage:(NSString *)message
{
    _loading = NO;
    if (_networkUnavailableView == nil) {
        _networkUnavailableView = [[PYNetworkUnavailableView alloc] initWithFrame:self.bounds];
    }
    _networkUnavailableView.message = message;
   __weak __typeof(&*self) weakSelf = self;
    [_networkUnavailableView setReloadBlock:^(){
       
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        if ([weakSelf.target respondsToSelector:weakSelf.action]) {
            [weakSelf.target performSelector:weakSelf.action withObject:weakSelf];
        }
#pragma clang diagnostic pop

            [weakSelf show];
    }];
    [self addSubview:_networkUnavailableView];
}


- (void)layoutSubviews
{
    _logoImageView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5,CGRectGetHeight(self.frame) * 0.4);
    _activityView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetMaxY(_logoImageView.frame) + CGRectGetHeight(_activityView.frame) * 0.5 +Margin);
    _networkUnavailableView.frame = self.bounds;
}

@end
