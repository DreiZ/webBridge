//
//  DSWKwebview.m
//  dspider
//
//  Created by 杜文 on 16/12/28.
//  Copyright © 2016年 杜文. All rights reserved.
//

#import "DWKwebview.h"
#import "JSBUtil.h"
#import "ZPublicManager.h"
typedef void(^completionHandler) (NSString * _Nullable result);

@interface DWKwebview () <UITextFieldDelegate>
@property (nonatomic, strong) NSString *inputText;
@property (nonatomic, strong) completionHandler completionHandlerBlock;
@end

@implementation DWKwebview

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    //NSString * js=@"function setupWebViewJavascriptBridge(b){var a={call:function(d,c){return prompt('_dspiercall='+d,c)}};b(a)};";
    
    NSString * js=[@"_dswk='_dsbridge=';" stringByAppendingString: INIT_SCRIPT];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                               forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:script];
    WKUserScript *scriptDomReady = [[WKUserScript alloc] initWithSource:@";prompt('_dsinited');"
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                       forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:scriptDomReady];
    self = [super initWithFrame:frame configuration: configuration];
    if (self) {
        super.UIDelegate = self;
        super.navigationDelegate = self;
    }
    return self;
}

#pragma mark WKWebView代理方法 WKNavigationDelegate 协议
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if( self.DSNavigationDelegate &&  [self.DSNavigationDelegate respondsToSelector:
                               @selector(webView:didStartProvisionalNavigation:)])
    {
        return [self.DSNavigationDelegate webView:webView didStartProvisionalNavigation:navigation];
    }else{
        NSLog(@"suprewebView 开始加载");
    }
}

// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    if( self.DSNavigationDelegate &&  [self.DSNavigationDelegate respondsToSelector:
                                     @selector(webView:didCommitNavigation:)])
    {
        return [self.DSNavigationDelegate webView:webView didCommitNavigation:navigation];
    }else{
        NSLog(@"suprewebView 内容开始返回");
        [[ZPublicManager shareInstance] showHud];
    }
}
// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if( self.DSNavigationDelegate &&  [self.DSNavigationDelegate respondsToSelector:
                                     @selector(webView:didFinishNavigation:)])
    {
        return [self.DSNavigationDelegate webView:webView didFinishNavigation:navigation];
    }else{
        NSLog(@"suprewebView 页面加载完成");
        [[ZPublicManager shareInstance] hideHud];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    if( self.DSNavigationDelegate &&  [self.DSNavigationDelegate respondsToSelector:
                                     @selector(webView:didFailNavigation:withError:)])
    {
        return [self.DSNavigationDelegate webView:webView didFailNavigation:navigation withError:error];
    }else{
        NSLog(@"suprewebView 内容开始返回");
    }
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
     NSLog(@"在发送请求之前，决定是否跳转");
//    decisionHandler(WKNavigationActionPolicyAllow);
    if (self.DSNavigationDelegate &&[self.DSNavigationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.DSNavigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
   
}

#pragma mark WKUIDelegate 相关
//带输入框弹窗
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    NSString * prefix=@"_dsbridge=";
    if ([prompt hasPrefix:prefix])
    {
        NSString *method= [prompt substringFromIndex:[prefix length]];
        NSString *result =[JSBUtil call:method :defaultText JavascriptInterfaceObject:_JavascriptInterfaceObject jscontext:webView];
        completionHandler(result);
    }else if([prompt hasPrefix:@"_dsinited"]){
        completionHandler(@"");
        if(javascriptContextInitedListener) javascriptContextInitedListener();
        
    }else {
        if(self.DSUIDelegate && [self.DSUIDelegate respondsToSelector:
                                 @selector(webView:runJavaScriptTextInputPanelWithPrompt
                                           :defaultText:initiatedByFrame
                                           :completionHandler:)])
        {
            return [self.DSUIDelegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt
                                  defaultText:defaultText
                             initiatedByFrame:frame
                            completionHandler:completionHandler];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:prompt message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *txtName = [alert textFieldAtIndex:0];
            txtName.text=defaultText;
            //测试用  没完成
            txtName.delegate = self;
            alert.delegate = self;
            //
            [alert show];
            while (!confirmDone){
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            confirmDone=false;
            completionHandler([txtName text]);
            
            //测试用 没完成
            _completionHandlerBlock = completionHandler;
            //
        }
    }
}

//警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(void))completionHandler
{
    if( self.DSUIDelegate &&  [self.DSUIDelegate respondsToSelector:
                               @selector(webView:runJavaScriptAlertPanelWithMessage
                                         :initiatedByFrame:completionHandler:)])
    {
        return [self.DSUIDelegate webView:webView runJavaScriptAlertPanelWithMessage:message
                         initiatedByFrame:frame
                        completionHandler:completionHandler];
    }else{
//        UIAlertView *alertView =
//        [[UIAlertView alloc] initWithTitle:@"提示"
//                                   message:message
//                                  delegate:nil
//                         cancelButtonTitle:@"确定"
//                         otherButtonTitles:nil,nil];
//        completionHandler();
//        [alertView show];
        [[ZPublicManager shareInstance] showMessageTitle:@"提示" message:message hander:^(NSInteger buttonIndex) {
            completionHandler();
        } cancelButton:@"确定" otherButtonTitles:nil, nil];
    }
}

//确认框
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    if( self.DSUIDelegate && [self.DSUIDelegate respondsToSelector:
                              @selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)])
    {
        return[self.DSUIDelegate webView:webView runJavaScriptConfirmPanelWithMessage:message
                        initiatedByFrame:frame
                       completionHandler:completionHandler];
    }else{
        [[ZPublicManager shareInstance] showMessageTitle:@"提示" message:message hander:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                completionHandler(true);
            }else{
                completionHandler(false);
            }
        } cancelButton:@"取消" otherButtonTitles:@"确定", nil];
        
//        UIAlertView *alertView =
//        [[UIAlertView alloc] initWithTitle:@"提示"
//                                   message:message
//                                  delegate:self
//                         cancelButtonTitle:@"取消"
//                         otherButtonTitles:@"确定", nil];
//        [alertView show];
        while (!confirmDone){
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        confirmDone=false;
        completionHandler(confirmResult);
    }
}

#pragma mark 弹窗相关
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    confirmDone=true;
    confirmResult=buttonIndex==1?YES:NO;
    
}

- (void)setJavascriptContextInitedListener:(void (^)(void))callback
{
    javascriptContextInitedListener=callback;
}

- (void)loadUrl: (NSString *)url
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self loadRequest:request];//加载
}

-(void)callHandler:(NSString *)methodName arguments:(NSArray *)args completionHandler:(void (^)(NSString *  _Nullable))completionHandler
{
    if(!args){
        args=[[NSArray alloc] init];
    }
    NSString *script=[NSString stringWithFormat:@"%@.apply(null,%@)",methodName,[JSBUtil objToJsonString:args]];
    [self evaluateJavaScript:script completionHandler:^(id value,NSError * error){
        if(completionHandler) completionHandler(value);
    }];
}

@end


