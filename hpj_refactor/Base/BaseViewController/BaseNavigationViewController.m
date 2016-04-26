//
//  BaseNavigationViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "PYThemeManager.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if ([self.topViewController respondsToSelector:@selector(backAction)]) {
        [self.topViewController backAction];
    }
    return [super navigationBar:navigationBar shouldPopItem:item];
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


#pragma clang diagnostic push

#pragma clang diagnostic ignored"-Wincomplete-implementation"
@implementation UINavigationController (PopAction)

@end
#pragma clang diagnost
#pragma clang diagnostic pop

