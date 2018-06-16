//
//  ZBaseNetWorkManager.h
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kMAPI @"www.baidu.com"
#define kCompletionHandler completionHandler:(void(^)(id model, NSError *error))completionHandler

@interface ZBaseNetWorkManager : NSObject

#pragma mark get请求
+ (id)get:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler;
#pragma mark post请求
+ (id)post:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler;

//上传图片
+ (id)postImage:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler;
@end
