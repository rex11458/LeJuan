//
//  LHBLoadingView.h
//  lianhebao
//
//  Created by lwp on 14-11-13.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYLoadingView : UIView

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;


- (void)show;
- (void)showInView:(UIView *)view;

- (void)dismiss;

- (void)showErrorWithMessage:(NSString *)message;

@property (nonatomic,assign,getter=isLoading) BOOL loading;


+ (PYLoadingView *)loadingViewWithTarget:(id)target action:(SEL)action;

@end
