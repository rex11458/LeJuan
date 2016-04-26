//
//  PYTask.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    
    PYTaskDownloadedType,
    PYTaskUndownloadType,
    PYTaskHistoryType,
    
} PYTaskType;

@class PYTaskList;

@interface PYTask : NSObject <PYQuestionnaireProtocol>

@property (nonatomic, assign) BOOL isDownload;        // 是否已下载, N-未下载，Y-已下载



+ (NSString *)downloadType:(PYTaskType)type;

+ (PYTaskList *)taskListWithDictionary:(NSDictionary *)dictionary;


@end


@interface PYTaskList : BaseModel

@property (nonatomic, copy) NSArray<PYTask *> *list;

@end

@interface PYTaskDataSource : BaseDataSource

@property (nonatomic,assign) PYTaskType taskType;

@property (nonatomic, assign) NSInteger pageIndex;

- (instancetype)initWithTaskType:(PYTaskType)taskType;

@end