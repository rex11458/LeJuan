//
//  PYTask.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYTask.h"
#import "PYTaskHanlder.h"
#import "PYLoginUserManager.h"
#import "PYTaskViewCell.h"
@implementation PYTask

@synthesize resultId;
@synthesize paperId;
@synthesize prjName;
@synthesize paperTitle;

@synthesize objCode;
@synthesize objName;
@synthesize addr;
@synthesize addrx;
@synthesize addry;

@synthesize resultStatus;
@synthesize statusText;
@synthesize version;
@synthesize area;
@synthesize city;

@synthesize startDate;
@synthesize endDate;
@synthesize paperInfo;
@synthesize province;
@synthesize progress;

@synthesize isArrival;
@synthesize arrivalTime;

@synthesize isDeparture;
@synthesize departureTime;

@synthesize leaveRemark;

+ (NSString *)downloadType:(PYTaskType)type
{
    NSString *realType = @"";
    switch (type) {
        case PYTaskUndownloadType:
            realType = @"N";
            break;
        case PYTaskDownloadedType:
            realType = @"Y";
            break;
        case PYTaskHistoryType:
            realType = @"H";
            
            break;
        default:
            break;
    }
    return realType;
}

+ (PYTaskList *)taskListWithDictionary:(NSDictionary *)dictionary
{
    [PYTaskList mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list" : [PYTask class]
                 };
    }];
    PYTaskList *taskList = [PYTaskList mj_objectWithKeyValues:dictionary];

    return taskList;
}

@end

@implementation PYTaskList


@end

@interface PYTaskDataSource ()
{
    NSURLSessionTask *_sessionTask;
}
@end

@implementation PYTaskDataSource

- (instancetype)initWithTaskType:(PYTaskType)taskType
{
    if (self = [super init]) {
        self.taskType = taskType;
    }
    
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if (self.taskType == PYTaskDownloadedType) {
        
        //从本地数据库读取
        
        self.dataArray = [[PYQuestionnaireManager sharedInstance] selectQuestionnairesWithUserLoginName:[PYLoginUserManager shareInstance].loginUser.loginName];
        
        if (self.dataArray.count == 0)
            failure(NSLocalizedString(@"noDownloadQuestionnaire", nil));
        else
            success(self.dataArray);
        return;
    }
    
    if (type == 0) {
        self.pageIndex = 0;
    }else{
        self.pageIndex ++;
    }
   _sessionTask = [PYTaskHanlder getTaskListWithUserLoginId:[PYLoginUserManager shareInstance].loginUser.userLoginId type:self.taskType pageIndex:self.pageIndex success:^(NSArray *dataArray) {

        if (type == 0)
        {
            self.dataArray = dataArray;
            success(self.dataArray);
        }
        else
        {
            if (dataArray.count == 0)
                failure(NSLocalizedString(@"NoMoreData", nil));
            else
            {
                self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:dataArray];
            }
                success(self.dataArray);
        }
        
    } failure:failure];
}

- (void)cancelTask
{
    [PYAppNetWorkClient cancelTask:_sessionTask];
}

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PYTaskViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PYTaskViewCellId" forIndexPath:indexPath];

    [self fillData:[self.dataArray objectAtIndex:indexPath.row] cell:cell];
  
    return cell;
}

- (void)fillData:(PYTask *)task cell:(PYTaskViewCell *)cell
{
    cell.storeNoLabel.text = [NSString stringWithFormat:@"门店编号:%@",task.objCode];
    cell.storeNameLabel.text = [NSString stringWithFormat:@"门店名称:%@",task.objName];
    cell.storeTypeLabel.text =  [NSString stringWithFormat:@"门店类型:%@",task.paperTitle];
    cell.storeDateLabel.text = [NSString stringWithFormat:@"%@  %@",task.startDate,task.endDate];
    
    cell.statusLabel.hidden = (self.taskType != PYTaskDownloadedType);
    
    if (self.taskType == PYTaskDownloadedType) {

    
        [cell verification:task];
    
    }
}

@end