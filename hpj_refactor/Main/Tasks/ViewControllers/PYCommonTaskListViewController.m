//
//  PYCommonTaskListViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/19.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYCommonTaskListViewController.h"

@interface PYCommonTaskListViewController ()

@end

@implementation PYCommonTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setSourceFromSearch:(BOOL)sourceFromSearch
{
    _sourceFromSearch = sourceFromSearch;
    
    if (_sourceFromSearch) {
        
        //隐藏搜索按钮
        NSMutableArray *items = [self.navigationItem.rightBarButtonItems mutableCopy];
        if (items.count > 0) {
            [items removeObjectAtIndex:0];
        }
        
        self.navigationItem.rightBarButtonItems = items;
        
        self.navigationItem.title = @"搜索结果";
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
