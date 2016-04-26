//
//  PYCommonTaskListViewController.h
//  hpj_refactor
//
//  Created by LiuRex on 16/3/19.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PYCommonTaskListViewController : BaseTableViewController

@property (nonatomic, strong) PYTaskDataSource *dataSource;

@property (nonatomic, assign) BOOL sourceFromSearch;

@end
