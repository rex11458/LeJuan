//
//  PYUserHomeViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/19.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYUserHomeViewController.h"

@interface PYUserHomeViewController ()
- (IBAction)logoutAction:(id)sender;
- (IBAction)aboutAction:(id)sender;

@end

@implementation PYUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

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

- (IBAction)logoutAction:(id)sender {
    
    
    [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"sureLogout", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{

    }] otherButtonItems:[RIButtonItem itemWithLabel:@"确定"  action:^{
        
        [self logout];
        
    }], nil] show];
    
}

- (IBAction)aboutAction:(id)sender {
    
    NSString *msg = [NSString stringWithFormat:@"当前版本%@", PYAppVsersion];
    [[[UIAlertView alloc] initWithTitle:@"关于" message:msg cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:nil] otherButtonItems:nil] show];
}

- (void)logout
{
    [PYLoginUserManager saveUserLogoffInfo];
    self.view.window.rootViewController = [PYMainStoryboard instantiateInitialViewController];

}

@end
