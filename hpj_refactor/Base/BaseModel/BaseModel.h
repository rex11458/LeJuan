//
//  BaseModel.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/30.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"
@interface BaseModel : NSObject

@property (nonatomic, copy) NSString *errorMsg;

@property (nonatomic,assign, readonly) BOOL status;   //YES数据返回成功，NO失败

@end


@interface BaseDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign) NSInteger refreshType;

- (void)loadDataType:(NSInteger)type Success:(SuccessBlock)success failure:(FailureBlock)failure;
- (void)cancelTask;

@end