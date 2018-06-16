//
//  ZBaseNetWorkManager.m
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZBaseNetWorkManager.h"

@implementation ZBaseNetWorkManager
+ (AFHTTPSessionManager *)defaultAFManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        //记录网络状态
        [manager.reachabilityManager startMonitoring];
    });
    return manager;
}

#pragma mark get请求
+ (id)get:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *newUrl = [self getMUrl:path];
    
    if ([self defaultAFManager].reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
//        error.errorMsg = @"网络无法连接";
        completionHandler(nil,error);
        return nil;
    }
    
    return [[self defaultAFManager] GET:newUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil, error);
    }];
}

#pragma mark post请求
+ (id)post:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *newUrl = [self getMUrl:path];
    if ([self defaultAFManager].reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
        //        error.errorMsg = @"网络无法连接";
        completionHandler(nil,error);
        return nil;
    }
    return [[self defaultAFManager] POST:newUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil, error);
    }];
}


//上传图片
+ (id)postImage:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler{
    NSString *newUrl = [self getMUrl:path];
    
    return [[self defaultAFManager] POST:newUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (id key in params[@"imageKey"]) {
            UIImage *image = [params objectForKey:key];
            if (image == nil) {
                return ;
            }
            NSData* tempData = UIImagePNGRepresentation(image);
            if (tempData == nil) {
                return;
            }
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil, error);
    }];
}


+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params {
    NSMutableString *percentPath = [NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else {
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString*)getMUrl:(NSString*)url {
    return [NSString  stringWithFormat:@"%@/%@",kMAPI,url];
}


#pragma mark 签名
+(NSMutableDictionary*)signTheParameters:(NSString *)urlStr postDic:(NSDictionary *)postDic {
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] init];
    
    [parameterDic addEntriesFromDictionary:postDic];
    for (NSString *key  in [parameterDic allKeys]) {
        [parameters addObject:[NSString stringWithFormat:@"%@=%@",key,parameterDic[key]]];
    }
    
    // 根据key排序值
    NSArray *sortedArray = [parameters sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (NSString *key in sortedArray) {
        NSRange range = [key rangeOfString:@"="];
        NSString *newKey = [key substringToIndex:range.location];
        NSString *valueStr;
        
        if([parameterDic[newKey] isKindOfClass:[NSArray class]] || [parameterDic[newKey] isKindOfClass:[NSDictionary class]]){
            valueStr = [ZBaseNetWorkManager toJSONString:parameterDic[newKey]];
            
            [parameterDic setObject:valueStr forKey:newKey];;
        }else{
            valueStr = parameterDic[newKey];
        }
        // 拼接值 字符串
        if (valueStr) {
            if ([valueStr isKindOfClass:[NSNumber class]]) {
                valueStr = [NSString stringWithFormat:@"%ld",(long)[valueStr integerValue]];
            }
            [resultStr appendString:valueStr];
        }
    }
    // 拼接 私钥
    [resultStr insertString:@"hntx_murmur_of_the_heart" atIndex:0];
    // MD5加密
    NSString *MD5Str = [resultStr md5String];
    // 生成sign值
    [parameterDic setObject:MD5Str forKey:@"sign"];
    // 去掉service
    [parameterDic removeObjectForKey:@"service"];
    return parameterDic;
}


+ (NSString *)toJSONString:(id)object{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
    if (jsonData.length > 0 && error == nil ) {
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}
@end
