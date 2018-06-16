//
//  ZPublicWebVC.m
//  ZProject
//
//  Created by zzz on 2018/6/15.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZPublicWebVC.h"
#import "MJRefresh.h"

#define hngViewHegight self.view.frame.size.height
#define TopHeight (hngViewHegight == 812.0 ? 44 : 20)

#define WEBURL @"http://47.100.160.168:8083/weChatFans/selectAll"

@interface ZPublicWebVC ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *iWebView;
@end

@implementation ZPublicWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWebView];
}

- (void)initWebView {
    
    
    _iWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _iWebView.delegate = self;
    [_iWebView setBackgroundColor:[UIColor whiteColor]];
    
    __weak typeof(self)weakSelf = self;
    _iWebView.scrollView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.iWebView reload];
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:WEBURL]];
    [_iWebView loadRequest:request];
    [self.view addSubview:_iWebView];
    
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TopHeight)];
    topBackView.backgroundColor = [UIColor colorWithRed:51.0f/255 green:50.0f/255 blue:56.0f/255 alpha:1];
    [self.view addSubview:topBackView];
    
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_iWebView.scrollView.mj_header endRefreshing];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_iWebView.scrollView.mj_header endRefreshing];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

@end
