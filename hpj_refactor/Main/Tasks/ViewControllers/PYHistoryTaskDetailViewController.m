//
//  PYHistoryTaskDetailViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/19.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYHistoryTaskDetailViewController.h"

@interface PYHistoryTaskDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PYHistoryTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    [_webView loadRequest:request];

}

- (void)setUrl:(NSString *)url
{
    if (url == _url && url == nil) {
        return ;
    }
    
    _url = [url copy];

}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView animationWithStyle:UIActivityIndicatorViewStyleGray];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView endAnimation];
    
    
    //禁止用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    //禁止长按弹出选择框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
