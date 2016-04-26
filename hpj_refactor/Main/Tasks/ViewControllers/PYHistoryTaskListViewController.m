//
//  PYHistoryTaskListViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYHistoryTaskListViewController.h"
#import "PYTask.h"
#import <MJRefresh/MJRefresh.h>
#import "PYUndownloadTaskDetailViewController.h"
#import "BaseNavigationViewController.h"
#import "PYHistoryTaskDetailViewController.h"
#import "PYSearchViewController.h"
@interface PYHistoryTaskListViewController ()


@end

@implementation PYHistoryTaskListViewController

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
        PYTaskDataSource *dataSource = [[PYTaskDataSource alloc] initWithTaskType:PYTaskHistoryType];
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
    PYTask *task = [self.dataSource.dataArray objectAtIndex:indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"%@/jsp/paper/PaperDetail.jsp?paperId=%@&resultId=%@",PYBaseURL,task.paperId,task.resultId];
    
    PYHistoryTaskDetailViewController *vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYHistoryTaskDetailViewController class])];
    vc.url = urlString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)refresh
{
    [self.dataSource loadDataType:0 Success:^(NSArray *dataArray) {
        
        [self.tableView.mj_header endRefreshing];
        [self.loadingView dismiss];
        
        if (dataArray.count == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"没有下载历史记录!"];
            
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"historySearchSegueId"]) {
        PYSearchViewController *vc = segue.destinationViewController;
        vc.taskType = PYTaskHistoryType;
    }
}

@end
