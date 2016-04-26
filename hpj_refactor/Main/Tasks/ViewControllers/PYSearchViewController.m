//
//  PYSearchViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/6.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYSearchViewController.h"
#import "PYTaskHanlder.h"
#import "PYLoginUserManager.h"
#import <KxMenu/KxMenu.h>
#import "PYHistoryRecord.h"
#import "PYSearchRecordViewCell.h"
#import "PYCommonTaskListViewController.h"
#import "PYUndownloadTaskListViewController.h"
#import "PYDownloadedTaskListViewController.h"
#import "PYHistoryTaskListViewController.h"

#define PY_SEARCH_TYPE_BIANHAO        @"门店编号"
#define PY_SEARCH_TYPE_MINGCHEN       @"门店名称"

@interface PYSearchViewController ()<UITextFieldDelegate,PYSearchRecordViewCellDelegate>
{
    UIButton *_searchTypeButton;
    NSInteger _searchType;
    NSMutableArray<PYHistoryRecord *> *_historyRecords;
    
    NSArray<PYTask *> *_dataArray;
    
}
- (IBAction)removeAllRecordAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (strong, nonatomic)  UITextField *searchTextField;

@end

@implementation PYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchType = 0;
    
    [self loadData];
    
    [self configSubViews];
}

- (void)loadData
{
    _historyRecords = [[PYLoginUserManager historySearchRecordsWithTaskType:_taskType searchType:_searchType] mutableCopy];
  
    if (_historyRecords == nil) {
        _historyRecords = [NSMutableArray array];
    }
    
    [self refreshFooterViewStatus];
    
    [self.tableView reloadData];
}

- (void)configSubViews
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[];
    /*!
     *  searchTextField
     */
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.frame = CGRectMake(0, 0, self.view.frame.size.width  - 70, 30);
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.keyboardType = UIKeyboardTypeDefault;
    _searchTextField.placeholder = @"请输入搜索内容";
    _searchTextField.font = PY_MIDDLE_SYSTEM_FONT;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTextField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:243.0/255.0  blue:236.0/255.0  alpha:1.0];
    _searchTextField.delegate = self;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = _searchTextField;
    /*!
     * leftView
     */
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [leftView setBackgroundColor:[UIColor clearColor]];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchTypeButton = button;
    button.frame = CGRectMake(5, 0, 60, 30);
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal | UIControlStateSelected];

    [button setTitle:PY_SEARCH_TYPE_BIANHAO forState:UIControlStateNormal];

    [button setTitleColor:PY_LEVEL_2_FONT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:PY_MIDDLE_SYSTEM_FONT];
    [button addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:button];
    UIImageView *imgage = [[UIImageView alloc] initWithFrame:CGRectMake(62, 3, 20, 20)];
    imgage.backgroundColor = [UIColor clearColor];
    imgage.image = [UIImage imageNamed:@"arrow_down"];
    [leftView addSubview:imgage];
    _searchTextField.leftView = leftView;
}

#pragma mark - 
- (void)searchTypeAction:(UIButton *)button
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:PY_SEARCH_TYPE_BIANHAO
                     image:nil
                    target:self
                    action:@selector(itemAction:)],
      
      [KxMenuItem menuItem:PY_SEARCH_TYPE_MINGCHEN
                     image:nil
                    target:self
                    action:@selector(itemAction:)]
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(button.frame.origin.x,
                                      button.frame.origin.y - 30,
                                      button.frame.size.width,
                                      button.frame.size.height)
                 menuItems:menuItems];
}

- (void)itemAction:(KxMenuItem *)item
{
    [_searchTypeButton setTitle:item.title forState:UIControlStateNormal];

    _searchType = [item.title isEqualToString:PY_SEARCH_TYPE_BIANHAO] ? 0 : 1;
    
    [self loadData];
}

#pragma mark - searchAction
- (void)searchWithKey:(NSString *)sKey
{
    if (sKey.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入门店名称或门店编号!"];
        return;
    }
    
    PYHistoryRecord *record = [[PYHistoryRecord alloc] initWithTaskType:_taskType searchType:_searchType searchKey:sKey];
    
   BOOL ret = [PYLoginUserManager addHistorySearchRecord:record];
    
    if (ret) {
        if (_taskType == record.taskType) {
            [_historyRecords addObject:record];
        }
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_historyRecords.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self refreshFooterViewStatus];

    [SVProgressHUD showWithStatus:@"正在搜索" maskType:SVProgressHUDMaskTypeBlack];
    
    [PYTaskHanlder searchTask:PYCurrentUserLoginId pageIndex:0 record:record success:^(NSArray<PYTask *> *dataArray) {
        [SVProgressHUD dismiss];

        _dataArray = [dataArray copy];
        
        /*!
         *  跳转
         */
        [self jumpViewController];
        
        
    } failed:^(id error_msg) {
        [SVProgressHUD showErrorWithStatus:error_msg];
    }];
}

/*!
 *  根据TaskType跳转
 */
- (void)jumpViewController
{
    PYCommonTaskListViewController *vc = nil;
    
    switch (_taskType) {
        case PYTaskUndownloadType:
    
            vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYUndownloadTaskListViewController class])];

            break;
        case PYTaskDownloadedType:
            vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYDownloadedTaskListViewController class])];

            break;
        case PYTaskHistoryType:
            vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYHistoryTaskListViewController class])];

            break;
        default:
            break;
    }
    PYTaskDataSource *dataSource = [[PYTaskDataSource alloc] initWithTaskType:_taskType];
  
    dataSource.dataArray = _dataArray;
    vc.dataSource = dataSource;

    vc.sourceFromSearch = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate,UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PYSearchRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchViewCellId"];
    cell.delegate = self;
    PYHistoryRecord *record = [_historyRecords objectAtIndex:indexPath.row];
   
    cell.record = record;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PYHistoryRecord *record = [_historyRecords objectAtIndex:indexPath.row];
    [self searchWithKey:record.searchKey];
    
}

#pragma mark - PYSearchRecordViewCellDelegate
- (void)searchRecordViewCell:(PYSearchRecordViewCell *)cell delete:(PYHistoryRecord *)record
{
   BOOL ret = [PYLoginUserManager removeHistorySearchRecord:record];
    
    if (ret) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [_historyRecords removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self refreshFooterViewStatus];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -  refreshFooterViewStatus
- (void)refreshFooterViewStatus
{
    self.tableView.tableFooterView.hidden = (_historyRecords.count == 0);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString * sKey = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [self searchWithKey:sKey];
    
    [_searchTextField endEditing:YES];
    
    return YES;
}


#pragma mark - pop
- (IBAction)removeAllRecordAction:(id)sender {
    [PYLoginUserManager removeAllHistorySearchRecords:_taskType];
    [_historyRecords removeAllObjects];
    [self.tableView reloadData];
    
    [self refreshFooterViewStatus];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end



