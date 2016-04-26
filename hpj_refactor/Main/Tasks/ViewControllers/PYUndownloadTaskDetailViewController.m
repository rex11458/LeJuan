//
//  PYUndownloadTaskDetailViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYUndownloadTaskDetailViewController.h"
#import "PYUndownloadTaskDetailView.h"
#import "PYTask.h"
#import "PYTaskHanlder.h"
#import "PYSurveyViewController.h"
#import "PYLocationViewController.h"
@interface PYUndownloadTaskDetailViewController ()
{
    NSURLSessionTask *_sessionTask;
}

@property (strong, nonatomic) IBOutlet PYUndownloadTaskDetailView *taskDetailView;
- (IBAction)downloadAction:(id)sender;
- (IBAction)lookOverMapAction:(id)sender;

@end

@implementation PYUndownloadTaskDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _taskDetailView.task = self.task;
}

#pragma mark -
- (IBAction)downloadAction:(id)sender {
    
    if (!self.task.isDownload)
    {
        [self checkReachabilityStatus];
    }else
    {        
        PYSurveyViewController *vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYSurveyViewController class])];
        vc.task = self.task;
    
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)lookOverMapAction:(id)sender {
    
    //经度
    NSString *longitude = _task.addrx;
    //纬度
    NSString *latitude = _task.addry;
    
    if (longitude.length != 0 && latitude.length != 0) {
        PYLocationViewController *vc = [PYMainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([PYLocationViewController class])];
        vc.coordinate = (CLLocationCoordinate2D){[latitude doubleValue], [longitude doubleValue]};
        
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"没有经纬度信息!"];
    }
}


#pragma -download
- (void)checkReachabilityStatus
{
    switch (PYReachabilityStatus) {
            
        case NotReachable:
            [UIAlertView showWithMessage:NSLocalizedString(@"noNetwork", nil)];
            return;
        case ReachableViaWWAN:
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"WWANNetworkRemaind", nil) cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                [self download];
            }] otherButtonItems:[RIButtonItem itemWithLabel:@"取消"], nil] show];
        }
            break;
        default:
            [self download];
            break;
    }
}

- (void)download
{
    [_taskDetailView.downLoadButton animationWithStyle:UIActivityIndicatorViewStyleWhite];
  _sessionTask = [PYTaskHanlder downloadTask:self.task.paperId resultId:self.task.resultId success:^(id obj) {
        
        [self endDownload:YES];
      
      if (_downloadSuccessBlock) {
          _downloadSuccessBlock(_task);
      }
      
    } failure:^(id error_msg) {
      
        [self endDownload:NO];
        
        [SVProgressHUD showErrorWithStatus:error_msg];
    }];
}

- (void)endDownload:(BOOL)success
{
    NSString *title = nil;
    
    if (success) {
     
        self.task.isDownload = success;
        //问卷task存入数据库
        [[PYQuestionnaireManager sharedInstance] insertQuestionnaire:_task relationloginName:[PYLoginUserManager shareInstance].loginUser.loginName];
        //buttonTitle
        title = NSLocalizedString(@"doQuestionnire", nil);
    }

    [_taskDetailView.downLoadButton endAnimatingWithTitle:title];
}

- (void)backAction
{
    if (_sessionTask != nil && _sessionTask.state == NSURLSessionTaskStateRunning) {
        [_sessionTask suspend];
        
       __block BOOL flag = NO;

        RIButtonItem *sureItem = [RIButtonItem itemWithLabel:@"是" action:^{
        
            [_sessionTask resume];
            if (_downloadSuccessBlock) {
                _downloadSuccessBlock(_task);
            }
            
            flag = YES;
        }];
        
        RIButtonItem *resumeItem = [RIButtonItem itemWithLabel:@"否" action:^{
            [_sessionTask cancel];
            flag = YES;

        }];
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"QuestionnaireRemaind", nil) cancelButtonItem:sureItem otherButtonItems:resumeItem, nil] show];
        while (!flag) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

@end
