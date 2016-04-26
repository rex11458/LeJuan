//
//  LHBBaseView.h
//  lianhebao
//
//  Created by lwp on 14-10-11.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseViewDelegate;


@interface BaseView : UIView

@property (nonatomic, assign) id<BaseViewDelegate>delegate;

- (void)loadViewWithParams:(NSArray *)params;


@end



@protocol BaseViewDelegate <NSObject>
@optional
- (void)baseView:(BaseView *)baseView actionWtihTag:(NSInteger)actionTag values:(id)values;

@end
