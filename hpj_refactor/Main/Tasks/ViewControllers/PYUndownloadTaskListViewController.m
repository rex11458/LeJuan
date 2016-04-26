//
//  PYUndownloadTaskListViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYUndownloadTaskListViewController.h"
#import "PYTask.h"
#import <MJRefresh/MJRefresh.h>
#import "PYUndownloadTaskDetailViewController.h"
#import "BaseNavigationViewController.h"
#import "PYSearchViewController.h"
@interface PYUndownloadTaskListViewController ()

@end

@implementation PYUndownloadTaskListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setSourceFromSearch:(BOOL)sourceFromSearch
{
    [super setSourceFromSearch:sourceFromSearch];
    
    [self configData];
}

- (void)configData
{
    if (!self.sourceFromSearch) {
        PYTaskDataSource *dataSource = [[PYTaskDataSource alloc] initWithTaskType:PYTaskUndownloadType];
        self.tableView.dataSource = dataSource;
        self.dataSource = dataSource;
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        
        [self refresh];
        
        self.loadingView = [PYLoadingView loadingViewWithTarget:self action:@selector(refresh)];
        [self.loadingView show];
        
        
        
    }else
    {
        self.tableView.dataSource = self.dataSource;
        
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PYUndownloadTaskDetailViewController *vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYUndownloadTaskDetailViewController class])];
    vc.task = [self.dataSource.dataArray objectAtIndex:indexPath.row];
    vc.downloadSuccessBlock = ^(PYTask *task){
        
        NSMutableArray *dataArray = [self.dataSource.dataArray mutableCopy];
        [dataArray removeObject:task];
        self.dataSource.dataArray = dataArray;
        [self.tableView reloadData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
- (void)refresh
{
    [self.dataSource loadDataType:0 Success:^(NSArray *dataArray) {
    
        [self.tableView.mj_header endRefreshing];
        [self.loadingView dismiss];
        
        if (dataArray.count == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"没有未下载的问卷!"];
            
            return ;
        }
        
        
        [self reloadData];
    } failure:^(id error_msg) {
        [self.tableView.mj_header endRefreshing];
        [self.loadingView showErrorWithMessage:error_msg];
        [SVProgressHUD showErrorWithStatus:error_msg];
    }];
}

- (void)loadMore
{
    [self.dataSource loadDataType:1 Success:^(id obj) {
        [self.tableView.mj_footer endRefreshing];
        
        [self reloadData];
    } failure:^(id error_msg) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error_msg];
    }];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"undownloadSearchSegueId"]) {
        PYSearchViewController *vc = segue.destinationViewController;
        vc.taskType = PYTaskUndownloadType;
    
    }
}

//#pragma mark - backAction
//- (void)backAction
//{
//    [_dataSource cancelTask];
//}


@end
