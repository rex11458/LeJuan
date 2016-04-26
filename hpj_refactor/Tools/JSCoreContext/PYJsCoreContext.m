//
//  PYJsCoreContext.m
//  hpj_refactor
//
//  Created by LiuRex on 16/2/3.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYJsCoreContext.h"
#import "PYQuestionnaireSection.h"
#import "PYQuestionItem.h"
@implementation PYJsCoreContext

- (instancetype)initWithWebView:(UIWebView *)webView
{
    if (self = [super init]) {
        _webView = webView;
#warning -- JSContext 偶尔会崩溃 什么原因？？
        _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        //禁止用户选择
        [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        //禁止长按弹出选择框
        [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    }
    return self;
}

//获取问卷数据
- (NSArray *)questionnaireResult
{
//    JSValue *stringValue = [_context evaluateScript:@"Paper.getResult()"];
//    PYLog(@"jsString = %@",stringValue);
    //将String转为Array
//   JSValue *arrayVlaue = [_context evaluateScript:[NSString stringWithFormat:@"eval('%@')",[stringValue toString]]];
    
    NSString *ret = [_webView stringByEvaluatingJavaScriptFromString:@"Paper.getResult()"];
    
    
    return [ret mj_JSONObject];
}

//回填问卷数据
- (void)fillBackQuestionnaireWithId:(NSString *)resultId;
{
   NSArray *fillBackArray = [[PYQuestionnaireManager sharedInstance] selectQuestionsByQuestionnaireId:resultId relationLoginName:[PYLoginUserManager shareInstance].loginUser.loginName];

    [_context evaluateScript:[NSString stringWithFormat:@"Paper.backfillResult(%@)",[fillBackArray mj_JSONString]]];
}

//获取问卷填写进度
- (CGFloat)questionnaireCompletedRate
{
   NSString *ret = [_webView stringByEvaluatingJavaScriptFromString:@"Paper.getCompletionRate()"];

    
    
    return [ret floatValue];
}

//是否已完成
- (BOOL)isCompeleted
{
    [_webView stringByEvaluatingJavaScriptFromString:@"Paper.isValideForm()"];

    CGFloat progress = [self questionnaireCompletedRate];

    return (progress == 1);
}

//问卷分页内容
- (NSArray<PYQuestionnaireSection *> *)questionnaireSectionList
{
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"Paper.getPageList()"];
    
    return [PYQuestionnaireSection mj_objectArrayWithKeyValuesArray:result];;
}
//显示分页内容
- (void)showPage:(NSString *)pageId
{
  [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Paper.showPage(%@)",pageId]];
}

//题盘
- (NSArray<PYQuestionItem *> *)questionnairePanelList
{
//    JSValue *doubleValue = [_context evaluateScript:@"Paper.getQuestionPanel()"];
   NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"Paper.getQuestionPanel()"];

    NSArray<PYQuestionItem *> *items = [PYQuestionItem mj_objectArrayWithKeyValuesArray:result];
    
    
    return items;
}

- (void)scrollTopQuestionItemWithQustionId:(NSString *)questionId
{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Paper.scrollToQuestion(\'%@\')",questionId]];
}

//搜索内容
- (void)searchQuestionWithKey:(NSString *)key
{
//    JSValue *doubleValue = [_context evaluateScript:];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Paper.searchQuestion(\'%@\')",key]];
}

//设置Image
- (void)setQuestionImageWithId:(NSString *)questionId subId:(NSString *)subId answerId:(NSString *)answerId imagePath:(NSString *)imagePath
{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Paper.setImage(\'%@\',\'%@\',\'%@\',\'%@\')",questionId,subId,answerId,imagePath]];
}


/*!
 *  保存时获取离店备注
 */
- (NSString *)getLeaveRemark
{
   return [_webView stringByEvaluatingJavaScriptFromString:@"Paper.getLeaveRemark()"];

}
/*!
 *  设置离店备注
 */
- (void)setLeaveRemark:(NSString *)remark
{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Paper.setLeaveRemarkText(\'%@\')",remark]];
}
@end
