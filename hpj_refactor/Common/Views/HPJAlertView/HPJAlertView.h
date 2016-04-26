//
//  HPJAlertView.h
//  hpJ
//
//  Created by LiuRex on 15/12/31.
//  Copyright © 2015年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HPJAlertViewDelegate;

@interface HPJAlertItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *imageName;


- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)color imageName:(NSString *)imageName;

@end


@interface HPJAlertView : UIView
{
    @private
    UILabel *_messageLabel;
    UIButton *_cancelButton;
}
@property (nonatomic,strong,readonly) UIWindow *window;

@property (nonatomic,copy) NSString *message;
@property (nonatomic, copy) NSString *cancelButtonTitle;

@property (nonatomic, copy) NSArray<HPJAlertItem *> *items;

@property (nonatomic,weak) id<HPJAlertViewDelegate> delegate;

- (instancetype)initWithMessage:(NSString *)message Items:(NSArray *)items cancelButtonTitle:(NSString *)title delegate:(id/*HPJAlertViewDelegate*/)delegate;

//
- (void)show;
@end

@protocol HPJAlertViewDelegate <NSObject>

@optional
- (void)alertView:(HPJAlertView *)alertView didSelectedIndex:(NSInteger)index;

@end
