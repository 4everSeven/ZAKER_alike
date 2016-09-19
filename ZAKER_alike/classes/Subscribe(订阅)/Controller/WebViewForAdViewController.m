//
//  WebViewForAdViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/9.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "WebViewForAdViewController.h"

@interface WebViewForAdViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation WebViewForAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIWebView *)webView {
	if(_webView == nil) {
		_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        //    webView.delegate = self;
        //
        //
        //
        //    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //
        //
        //    
        //    [webView loadRequest:request];
        
        _webView.delegate = self;
        NSURL *url = [NSURL URLWithString:self.urlPath];
        NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:requset];
        [self.view addSubview:_webView];
	}
	return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    //开始加载请求会执行此方法 返回值来决定是否允许访问
//    NSString *path = [request.URL description];
//    NSLog(@"%@",path);
//    //    if ([path containsString:@"baidu"]) {
//    //        return YES;
//    //    }
    return YES;
    
}
@end
