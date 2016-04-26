//
//  BaseViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import <MobClick.h>
@interface BaseViewController ()<BaseViewDelegate,UINavigationControllerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setBackBarButtonTitle:@""];
    
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)setBaseView:(BaseView *)baseView
{
    if (_baseView == baseView) return;
    _baseView = baseView;
    _baseView.delegate = self;
    [self.view addSubview:_baseView];
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionWtihTag:(NSInteger)actionTag values:(id)values{}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

static const char PYLoadingViewKey = '\0';

@implementation UIViewController (LoadingView)

- (UIView *)loadingView
{
    
    return objc_getAssociatedObject(self, &PYLoadingViewKey);
}

- (void)setLoadingView:(UIView *)loadingView
{
    if (loadingView == nil) {
        return;
    }
    if (loadingView != self.loadingView) {
        // 删除旧的，添加新的
        [self.loadingView removeFromSuperview];
        loadingView.frame = self.view.bounds;
        [self.view addSubview:loadingView];
        
        // 存储新的
        [self willChangeValueForKey:@"loadingView"]; // KVO
        objc_setAssociatedObject(self, &PYLoadingViewKey,
                                 loadingView, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"loadingView"]; // KVO
    }
}

@end


@implementation UIViewController (BackBarButtonItem)

- (void)setBackBarButtonTitle:(NSString *)title
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
}

@end

@implementation UIViewController (BackAction)

- (void)backAction
{
}

@end




