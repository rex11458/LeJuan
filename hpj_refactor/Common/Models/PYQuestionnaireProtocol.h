//
//  PYQuestionnaireProtocol.h
//  hpj_refactor
//
//  Created by LiuRex on 16/1/31.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@protocol PYQuestionnaireProtocol <NSObject,MJKeyValue>

@property (nonatomic, copy) NSString* resultId;         // 任务结果Id
@property (nonatomic, copy) NSString* resultStatus;     // 状态代码，N-未完成，Y-已完成

@property (nonatomic, copy) NSString* paperId;          // 问卷Id
@property (nonatomic, strong) NSString* paperInfo;
@property (nonatomic, copy) NSString* paperTitle;       // 问卷名称

@property (nonatomic, copy) NSString* objCode;          // 门店代码
@property (nonatomic, copy) NSString* objName;          // 门店名称

@property (nonatomic, copy) NSString* addr;             // 调查对象地址
@property (nonatomic, copy) NSString* addrx;            // 纬度
@property (nonatomic, copy) NSString* addry;            // 经度
@property (nonatomic, strong) NSString* area;

@property (nonatomic, strong) NSString* statusText;     // 状态文本
@property (nonatomic, strong) NSString* city;

@property (nonatomic, strong) NSString* startDate;      
@property (nonatomic, strong) NSString* endDate;
@property (nonatomic, strong) NSString* province;

@property (nonatomic, assign) float progress;           //进度

@property (nonatomic, copy) NSString* prjName;          // 项目名称

@property (nonatomic, copy) NSString* version;          // 版本号

@property (nonatomic, assign) BOOL isArrival;           //是否进店

@property (nonatomic, copy) NSString *arrivalTime;  //进店时间

@property (nonatomic, assign) BOOL isDeparture;  //是否离店

@property (nonatomic, copy) NSString *departureTime; //离店时间

@property (nonatomic, copy) NSString *leaveRemark;  //离店备注


@end
