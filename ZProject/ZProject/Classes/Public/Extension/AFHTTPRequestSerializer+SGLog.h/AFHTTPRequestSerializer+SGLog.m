//
//  AFHTTPRequestSerializer+SGLog.m
//  hntx
//
//  Created by 大海盗 on 2017/3/10.
//  Copyright © 2017年 zoomwoo. All rights reserved.
//

#import "AFHTTPRequestSerializer+SGLog.h"
#import "objc/runtime.h"
@implementation AFHTTPRequestSerializer (SGLog)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        SEL originalMethod =@selector(requestBySerializingRequest:withParameters:error:);
        SEL newMethod = @selector(sg_requestBySerializingRequest:withParameters:error:);
        [self exchageImplementWithClassStr:self originalMethod:originalMethod newMethod:newMethod];
    });
    
}

+(void)exchageImplementWithClassStr:(Class)class
                     originalMethod:(SEL)originalMethod
                          newMethod:(SEL)newMethod
{
//    Class class = NSClassFromString(classStr);
    Method fromMethod = class_getInstanceMethod(class, originalMethod);
    Method toMethod = class_getInstanceMethod(class, newMethod);
    method_exchangeImplementations(fromMethod, toMethod);
}

#pragma mark 打印接口日志
- (NSURLRequest *)sg_requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSString *query;
    NSURLRequest *mutableRequest  =[self sg_requestBySerializingRequest:request withParameters:parameters error:error];
    
    NSData *httpData = mutableRequest.HTTPBody;
    if (httpData) {
        query = [[NSString alloc] initWithData:httpData encoding:self.stringEncoding];
        
    }
    if (query) {
//        NSString *queryStr = [NSString stringWithFormat:@"%@?%@",request.URL,query];
//        NSLog(@"Query---  %@",queryStr);
        
    }
    NSLog(@"zzz:当前请求：%@", [request.URL.absoluteString stringByAppendingString:(query.length?[NSString stringWithFormat:@"?%@",query]:@"")]);
    return mutableRequest;
}
@end
