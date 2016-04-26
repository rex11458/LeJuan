//
//  PYHomeViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYHomeViewController.h"
#import "PYCommonTaskListViewController.h"
@interface PYHomeViewController ()

@end

@implementation PYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    UIViewController *vc = segue.destinationViewController;
    
    if ([vc isKindOfClass:[PYCommonTaskListViewController class]]) {
        PYCommonTaskListViewController *listVC = (PYCommonTaskListViewController *)vc;
        listVC.sourceFromSearch = NO;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
