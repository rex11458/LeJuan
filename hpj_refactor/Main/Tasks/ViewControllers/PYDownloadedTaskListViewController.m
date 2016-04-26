//
//  PYDownloadedTaskListViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYDownloadedTaskListViewController.h"
#import "PYTask.h"
#import "PYSurveyViewController.h"
#import "PYSurveyHandler.h"
#import "PYQuestion.h"
#import "PYSearchViewController.h"

#import <objc/runtime.h>

static PYDownloadedTaskListViewController *g_downloadedTaskListViewController = nil;

@interface PYDownloadedTaskListViewController ()
{
    NSMutableArray *_selectedTaskArray;
}
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIView *footerView;

- (IBAction)editAction:(UIButton *)sender;
- (IBAction)multiSelectionAction:(UIButton *)sender;
- (IBAction)uploadAction:(UIButton *)sender;

@end

@implementation PYDownloadedTaskListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    g_downloadedTaskListViewController = self;
    
    _footerView.hidden = YES;
    
}

- (void)setSourceFromSearch:(BOOL)sourceFromSearch
{
    [super setSourceFromSearch:sourceFromSearch];
    
    [self configData];
}

- (void)configData
{
    if (!self.sourceFromSearch) {
        
        PYTaskDataSource *dataSource = [[PYTaskDataSource alloc] initWithTaskType:PYTaskDownloadedType];
        
        self.tableView.dataSource = dataSource;
        self.dataSource = dataSource;
        [self reloadData];
        
    }else
    {
        self.tableView.dataSource = self.dataSource;
        [self reloadData];
    }
}

/*用于解耦合*/
- (void)method_exchangeImplementations
{
    py_swizzleInstanceMethod([PYTaskDataSource class], @selector(tableView:canEditRowAtIndexPath:), [self class], @selector(tableView:canEditRowAtIndexPath:));
    py_swizzleInstanceMethod([PYTaskDataSource class], @selector(tableView:commitEditingStyle:forRowAtIndexPath:), [self class], @selector(tableView:commitEditingStyle:forRowAtIndexPath:));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.sourceFromSearch) {
        [self loadData];
    }else{
        [self reloadData];
    }
    
    /*进入该VC时将PYDataSource的方法交给self执行*/
    [self method_exchangeImplementations];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    /*离开该VC时将self的方法还给PYTaskDataSource执行*/
    [self method_exchangeImplementations];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.isEditing) {
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PYSurveyViewController *vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYSurveyViewController class])];
        vc.task = [self.dataSource.dataArray objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        return UITableViewCellEditingStyleDelete |UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - 通过runtime 将dataSource的方法教给self执行
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
     
        PYTask *task = [g_downloadedTaskListViewController.dataSource.dataArray objectAtIndex:indexPath.row];
        
        return task.isDeparture;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
        [g_downloadedTaskListViewController deleteTask:[g_downloadedTaskListViewController.dataSource.dataArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark -
- (void)loadData
{
    [self.dataSource loadDataType:0 Success:^(NSArray *dataArray) {
        
        self.dataSource.dataArray = dataArray;
        
        [self reloadData];
        
    } failure:^(id error_msg) {

        [SVProgressHUD showErrorWithStatus:error_msg];
        [self reloadData];
    }];
}

- (void)reloadData
{
    [self refreshFooterViewStatus];
    [self.tableView reloadData];
}

//批量上传
- (void)mutiUploadAction {
    
    if (_selectedTaskArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先选择问卷!"];
        return;
    }
    [self editAction:_editButton];
    //检查网络状态
    [self checkReachabilityStatus];
}

#pragma mark - 检查网络状态
- (void)checkReachabilityStatus
{
    switch (PYReachabilityStatus) {
            
        case NotReachable:
            [UIAlertView showWithMessage:NSLocalizedString(@"noNetwork", nil)];
            return;
        case ReachableViaWWAN:
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"WWANNetworkUploadRemaind", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                [self uploadQuestionnaires];
            }] otherButtonItems:[RIButtonItem itemWithLabel:@"取消"], nil] show];
        }
            break;
        default:
            [self uploadQuestionnaires];
            break;
    }
}

#pragma mark - refreshFooterViewStatus
- (void)refreshFooterViewStatus
{
//    _multiUploadButton.hidden = !(self.dataSource.dataArray.count > 0);
}

#pragma mark - 上传问卷
- (void)uploadQuestionnaires
{
    dispatch_queue_t queue = dispatch_queue_create("uploadTask", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        __block int totalCount = (int)_selectedTaskArray.count;
        
        __block BOOL finished = NO;
        __block int currentIndex = 0;
        __block int faildCount = 0;
        
        dispatch_group_t uploadGroup = dispatch_group_create();
        
        for (PYTask *task in _selectedTaskArray) {
            
            currentIndex++;
            dispatch_group_enter(uploadGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传第%d/%d份问卷",currentIndex,totalCount] maskType:SVProgressHUDMaskTypeGradient];
            });
            
            NSArray *quesitons = [[PYQuestionnaireManager sharedInstance] selectQuestionsByQuestionnaireId:task.resultId relationLoginName:PYCurrentUserLoginName];
            NSArray<PYQuestion *> *a_questions = [PYQuestion mj_objectArrayWithKeyValuesArray:quesitons];
            
            [PYSurveyHandler uploadQuestionnaire:task questions:a_questions progress:nil success:^(id obj) {
                
                finished = YES;
                dispatch_group_leave(uploadGroup);
                
                [self deleteTask:task];
                
            } failure:^(id error_msg) {
                
                faildCount++;
                finished = YES;
                [SVProgressHUD showErrorWithStatus:error_msg];
                dispatch_group_leave(uploadGroup);
            }];
            
            while (!finished) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
        
        //问卷上传完成后显示结果
        dispatch_group_wait(uploadGroup, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%d份上传完成,%d份上传失败。",(totalCount - faildCount),faildCount]];
            
        });
    });
}

- (void)deleteTask:(PYTask *)task
{
    NSInteger index = [self.dataSource.dataArray indexOfObject:task];
    
    NSMutableArray *dataArray = [self.dataSource.dataArray mutableCopy];
    [dataArray removeObject:task];
    self.dataSource.dataArray = [dataArray copy];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self refreshFooterViewStatus];
    
    [[PYQuestionnaireManager sharedInstance] deleteQuestaionnaire:task relationLoginName:PYCurrentUserLoginName];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*!
     *  搜索
     */
    if ([segue.identifier isEqualToString:@"downloadSearchSegueId"]) {
        PYSearchViewController *vc = segue.destinationViewController;
        vc.taskType = PYTaskDownloadedType;
    }
}

/*!
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 */
- (IBAction)editAction:(UIButton *)sender {
    //    //取出所有完成的问卷
   NSMutableArray *completedTaskArray = [NSMutableArray array];
    for (PYTask *task in self.dataSource.dataArray) {
        
        //离店表示已经问卷已完成
        if (task.isDeparture) {
            [completedTaskArray addObject:task];
        }
    }
 
    if (completedTaskArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"还没有填写完成的问卷!"];
        return;
    }
    
    sender.selected = !sender.isSelected;
    
    _footerView.hidden = !sender.isSelected;
    
    [self.tableView setEditing:sender.isSelected animated:YES];
}

- (IBAction)multiSelectionAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    [self.dataSource.dataArray enumerateObjectsUsingBlock:^(PYTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (task.isDeparture) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            
            if (sender.isSelected) {
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }else
            {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }];
}

- (IBAction)uploadAction:(UIButton *)sender {
    _selectedTaskArray = [NSMutableArray array];
    NSArray<NSIndexPath *> *indexArray = [self.tableView indexPathsForSelectedRows];
    
    [indexArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PYTask *task = [self.dataSource.dataArray objectAtIndex:indexPath.row];
        [_selectedTaskArray addObject:task];
    
    }];
    
    [self mutiUploadAction];
    
}

@end
