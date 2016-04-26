//
//  YPLoginViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYLoginViewController.h"
#import "PYLoginView.h"
#import "PYQuestionnaireManager.h"
#import "PYHomeViewController.h"
#import "PYUserHandler.h"
#import "PYManagedUser.h"
@interface PYLoginViewController ()
@property (strong, nonatomic) IBOutlet PYLoginView *loginView;
- (IBAction)loginAction:(id)sender;

@end

@implementation PYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PYManagedUser *user =  [[PYQuestionnaireManager sharedInstance].getAllUser firstObject];
    _loginView.name = user.loginName;
    _loginView.password = user.userPassword;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

//登录
- (IBAction)loginAction:(id)sender {
    [self.loginView endEditing:YES];
    
    if (![self inputValueUsable]) return;
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"isLogging", nil) maskType:SVProgressHUDMaskTypeGradient];
    [PYUserHandler loginWithName:_loginView.name password:_loginView.password success:^(id obj) {
       
        [SVProgressHUD dismiss];
        
        if (![PYLoginUserManager verificationRealNameAndPhone])
        {
            [self performSegueWithIdentifier:@"improveInfoSeugeId" sender:nil];
        }else
        {
            UIViewController *vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:@"HomeNavigationId"];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        
    } failure:^(id error_msg) {
        [SVProgressHUD showErrorWithStatus:error_msg];

    }];
}

- (BOOL)inputValueUsable
{
    BOOL value = NO;
    NSString *username = _loginView.name;
    NSString *pwd     = _loginView.password;

    
    if (username.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空!"];
        
    } else if (pwd.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        
    }else{
        
        value = YES;
    }
    
    return value;
}




@end
