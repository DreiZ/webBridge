//
//  ZPublicBridgeWebVC.m
//  ZProject
//
//  Created by zzz on 2018/6/15.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZPublicBridgeWebVC.h"
#import "dsbridge.h"
#import "HNSeedDSBridgePublicTool.h"
#import "ZPublicManager.h"

@interface ZPublicBridgeWebVC ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) DWKwebview *iWebView;
@property (nonatomic, strong) HNSeedDSBridgePublicTool *JavascriptInterfaceObject;
@end

@implementation ZPublicBridgeWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initMainView];
}

- (void)initData {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initMainView {
    //    [self.view bringSubviewToFront:self.navigationView];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _iWebView = [[DWKwebview alloc] initWithFrame:CGRectMake(0, 20, kWindowW, kWindowH-20)];
    _iWebView.backgroundColor = [UIColor whiteColor];
    
    _strUrl = @"http://www.jikexueyuan.com/course/";
    _strUrl = [_strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    
    [_iWebView loadRequest:testRequest];
    _JavascriptInterfaceObject = [HNSeedDSBridgePublicTool shareSeedDSBridgeManagerWithNav:self];
    _iWebView.JavascriptInterfaceObject = _JavascriptInterfaceObject;
    _iWebView.DSUIDelegate = self;
    _iWebView.DSNavigationDelegate = self;
    _iWebView.scrollView.bounces = NO;
    [self.view addSubview:_iWebView];
}

#pragma mark WKWebView代理方法 WKNavigationDelegate 协议
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView 开始加载");
    [[ZPublicManager shareInstance] showHud];
    
}
// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"webView 内容开始返回");
}
// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView 页面加载完成");
    [[ZPublicManager shareInstance] hideHud];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    NSLog(@"webView 页面加载失败");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_iWebView && _JavascriptInterfaceObject) {
        [_JavascriptInterfaceObject callWebReload:_iWebView];
    }
}
@end
