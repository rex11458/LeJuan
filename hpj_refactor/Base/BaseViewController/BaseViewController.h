//
//  BaseViewController.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "PYLoadingView.h"
@interface BaseViewController : UIViewController

@property (nonatomic,strong) BaseView *baseView;


@end

@interface UIViewController (LoadingView)

@property (nonatomic, strong) PYLoadingView *loadingView;

@end

@interface UIViewController (BackBarButtonItem)

- (void)setBackBarButtonTitle:(NSString *)title;

@end


@interface UIViewController (BackAction)

- (void)backAction;

@end