//
//  PYImproveInfoViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYImproveInfoViewController.h"
#import "PYImproveTitleView.h"
#import "INTULocationManager.h"
#import "PYImproveInfoView.h"
@interface PYImproveInfoViewController ()
{
    PYImproveTitleView *_titleView;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButtonItem;
@property (strong, nonatomic) IBOutlet PYImproveInfoView *infoView;
@end

@implementation PYImproveInfoViewController

- (void)configTitleView
{
    _titleView = [[PYImproveTitleView alloc] initWithFrame:CGRectMake(0, 0, 150, 44.0f) target:self aciton:@selector(location)];
    self.navigationItem.titleView = _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self configTitleView];
    
    [self location];
}

- (IBAction)doneAction:(id)sender {
    
    if ([self inputValueUsable])
    {
        [self saveUserInfo];
        [self performSegueWithIdentifier:@"modelHomeSegueId" sender:nil];
    }
}

#pragma mark - 保存信息
- (void)saveUserInfo
{
    PYLoginUser *usr = [PYLoginUserManager shareInstance].loginUser;
    usr.userCity = _titleView.title;
    usr.userRealname = _infoView.realname;
    usr.userPhoneNumber = _infoView.phoneNum;
    [PYLoginUserManager saveUserLoginInfo];
    
    //存到数据库
    [[PYQuestionnaireManager sharedInstance] alterUserWithLoginName:PYCurrentUserLoginName newUser:usr];
}

#pragma mark -
- (BOOL)inputValueUsable
{
    BOOL value = NO;
    NSString *locationCity = _titleView.title;
    NSString *realName     = _infoView.realname;
    NSString *phoneName    = _infoView.phoneNum;
    
    if (locationCity.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"地理位置信息不能为空!"];
        
    } else if (realName.length < 2) {
        
        [SVProgressHUD showErrorWithStatus:@"姓名长度必须大于两位!"];
        
    }else if (phoneName.length < 11){
        
        [SVProgressHUD showErrorWithStatus:@"手机号必须为11位!"];
        
    }else{
        value = YES;
    }
    
    return value;
}

#pragma mark - 定位
- (void)location
{
    [_titleView startAnimating];
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:30 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        
#if TARGET_IPHONE_SIMULATOR//模拟器
     
        _titleView.title = @"上海市";
        [_titleView stopAnimating];
        [_infoView becomeFirstResponder];
        _doneButtonItem.enabled = YES;
        
#elif TARGET_OS_IPHONE//真机
        
        if (status == INTULocationStatusSuccess) {
            [self getLocalCity:currentLocation];
            
        }else if (status == INTULocationStatusServicesDisabled || status == INTULocationStatusServicesDenied){
            [_titleView stopAnimating];
            [self remindOpenLocationService];
        }
#endif

    }];

}

#pragma mark - 获取城市信息
- (void)getLocalCity:(CLLocation *)currentLocation
{
    [[CLGeocoder new] reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *locationCity = placemark.locality;
        if (locationCity == nil) {
            locationCity = placemark.administrativeArea;
        }
        _titleView.title = locationCity;
        [_titleView stopAnimating];
        [_infoView becomeFirstResponder];
        _doneButtonItem.enabled = YES;
    }];
}

#pragma mark - 提示授权定位服务
- (void)remindOpenLocationService
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    
    NSString *remaind = @"请打开定位服务,并允许\"乐卷网\"使用您的位置。";
    NSString * setting = nil;
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        setting = @"去设置";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:remaind delegate:self cancelButtonTitle:@"确定" otherButtonTitles:setting, nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
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

@end
