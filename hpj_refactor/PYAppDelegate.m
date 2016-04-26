//
//  AppDelegate.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYAppDelegate.h"
#import "PYThemeManager.h"
#import "PYUserHandler.h"
#import "PYSurveyViewController.h"
#import "PYImproveInfoViewController.h"
#import <MobClick.h>
@interface PYAppDelegate ()

@end

@implementation PYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [PYThemeManager defaultAppAppearance];
    if ([PYLoginUserManager isLogIn]) {
//    if (YES) {
        self.window.rootViewController = [PYMainStoryboard instantiateViewControllerWithIdentifier:@"HomeNavigationId"];
    }
    
    [self checkJsUpdate];
    
    [self initMob];
    
    return YES;
}

- (void)checkJsUpdate
{
    //先将NSBundle 问卷拷贝到沙盒目录
    
    NSString *fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"wenjuan"];
    NSString *desPath = PYQuestionnaireRootPath;
    if (![FCFileManager exifDataOfImageAtPath:desPath]) {
        [FCFileManager copyItemAtPath:fromPath toPath:desPath error:nil];
    }
    [PYUserHandler checkJsUpdateSuccess:nil failure:nil];
}

#pragma mark - 友盟统计
- (void)initMob
{
    //友盟
    [MobClick setAppVersion:PYAppVsersion];
    [MobClick startWithAppkey:PYUMengAnalyticsId reportPolicy:BATCH channelId:@""];
#if DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setLogEnabled:YES];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
}


- (void)saveData
{
    //应用关闭或进入后台时保存问卷数据
//    UIViewController *vc = _navigationController.viewControllers.lastObject;
//    
//    if ([vc isMemberOfClass:[SurveyViewController class]]) {
//        SurveyViewController *sureyVC = (SurveyViewController *)vc;
//        [sureyVC autoSaveData];
//    }

    UIViewController *vc =[self topViewController];
    if ([vc isMemberOfClass:[PYSurveyViewController class]]) {
        PYSurveyViewController *svc = (PYSurveyViewController *)vc;
        [svc saveQuestionnaire];
    }
}

//获取到最顶层的VC
- (UIViewController *)topViewController
{
    UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC.topViewController;
 
    if ([topVC isMemberOfClass:[PYImproveInfoViewController class]]) {
        
        UINavigationController *nvc = (UINavigationController *)topVC.presentedViewController;
        topVC = nvc.topViewController;
    }
    return topVC;
}

@end
