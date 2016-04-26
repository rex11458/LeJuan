//
//  BaseModel.m
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel



- (BOOL)status
{
    if (self.errorMsg == nil || self.errorMsg.length == 0)
        return YES;
    else
        return NO;
}

@end


@implementation BaseDataSource

- (instancetype)init
{
    if (self = [super init]) {
        _dataArray = [NSArray array];
    }
    return self;
}

- (instancetype)initWithRefreshType:(NSInteger)refreshType
{
    if (self = [self init]) {
        self.refreshType = refreshType;
    }
    return self;
}

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailureBlock)failure{}

- (void)cancelTask{}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"tableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}


@end