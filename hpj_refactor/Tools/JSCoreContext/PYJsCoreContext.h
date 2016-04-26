//
//  PYJsCoreContext.h
//  hpj_refactor
//
//  Created by LiuRex on 16/2/3.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <JavaScriptCore/JavaScript.h>
@class PYQuestionnaireSection;
@class PYQuestionItem;
@interface PYJsCoreContext : NSObject

@property (nonatomic, strong, readonly) JSContext *context;

@property (nonatomic, strong, readonly) UIWebView *webView;

- (instancetype)initWithWebView:(UIWebView *)webView;

//获取问卷数据
- (NSArray *)questionnaireResult;

//回填问卷数据
- (void)fillBackQuestionnaireWithId:(NSString *)resultId;

//获取问卷填写进度
- (CGFloat)questionnaireCompletedRate;
//问卷是否已完成
- (BOOL)isCompeleted;

//问卷分页内容
- (NSArray<PYQuestionnaireSection *> *)questionnaireSectionList;
//显示分页内容
- (void)showPage:(NSString *)pageId;

//题盘
- (NSArray<PYQuestionItem *> *)questionnairePanelList;

/*!
 *  定位到某个question
 *
 *  @return <#return value description#>
 */
- (void)scrollTopQuestionItemWithQustionId:(NSString *)questionId;

/*!
 *  搜索内容
 *
 *  @param key <#key description#>
 */
- (void)searchQuestionWithKey:(NSString *)key;

/*!
 *  设置Image
 *
 *  @param questionId <#questionId description#>
 *  @param subId      <#subId description#>
 *  @param answerId   <#answerId description#>
 *  @param imagePath  <#imagePath description#>
 */
- (void)setQuestionImageWithId:(NSString *)questionId subId:(NSString *)subId answerId:(NSString *)answerId imagePath:(NSString *)imagePath;

/*!
 *  保存时获取离店备注
 */
- (NSString *)getLeaveRemark;
/*!
 *  设置离店备注
 */
- (void)setLeaveRemark:(NSString *)remark;






@end
