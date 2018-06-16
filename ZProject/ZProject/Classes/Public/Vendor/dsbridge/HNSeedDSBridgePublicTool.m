//
//  HNSeedDSBridgePublicTool.m
//  hntx
//
//  Created by zww on 17/2/15.
//  Copyright © 2017年 zoomwoo. All rights reserved.
//

#import "HNSeedDSBridgePublicTool.h"
#import "ZBaseNetWorkManager.h"
#import "ZPublicBridgeWebVC.h"
#import "JSBUtil.h"
#import "AppDelegate.h"
#import "ZPublicManager.h"
#import "ZYImagePicker.h"


static HNSeedDSBridgePublicTool *shareSeedBridgeManager = NULL;
@interface HNSeedDSBridgePublicTool ()
@property (nonatomic, strong) ZYImagePicker *imagePicker;
@end
@implementation HNSeedDSBridgePublicTool

+(instancetype)shareSeedDSBridgeManager {
    @synchronized (self) {
        if (shareSeedBridgeManager == NULL) {
            shareSeedBridgeManager = [[HNSeedDSBridgePublicTool alloc] init];
        }
    }
    return shareSeedBridgeManager;
}

+ (instancetype)shareSeedDSBridgeManagerWithNav:(UIViewController *)nav {
//    @synchronized (self) {
//        if (shareSeedBridgeManager == NULL) {
//            shareSeedBridgeManager = [[HNSeedDSBridgePublicTool alloc] init];
//        }
//    }
//    shareSeedBridgeManager.nav = nav;
//    return shareSeedBridgeManager;
    HNSeedDSBridgePublicTool *seedBridgeManager = [[HNSeedDSBridgePublicTool alloc] init];
    seedBridgeManager.nav = nav;
    return seedBridgeManager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payBack:) name:@"alipay" object:nil];
}


- (void)payBack:(NSNotification *)notification {
    if (_paySuccess) {
        if (notification.userInfo[@"memo"]) {
            if((notification.userInfo[@"memo"][@"ResultStatus"] && [notification.userInfo[@"memo"][@"ResultStatus"] integerValue] == 9000) || (notification.userInfo[@"memo"][@"memo"] && [notification.userInfo[@"memo"][@"memo"] isEqualToString:@"成功"])) {
                _paySuccess([self getBackJsonStringWith:@{@"code":@"0"}]);
                return;
            }
        }
        _paySuccess([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
}


#pragma mark 回调
- (NSString *)testSyn:(NSDictionary *)args {

    return [(NSString *)[args valueForKey:@"msg"] stringByAppendingString:@"[ syn call]"];
    
}

- (NSString *)testAsyn:(NSDictionary *)args :(void (^)( NSString* _Nullable result))completionHandler {
    completionHandler([JSBUtil objToJsonString:@{@"iso":@"zzz"}]);
    return nil;
}



- (NSString *)closeForm:(NSDictionary *)args {
    
    return [(NSString *)[args valueForKey:@"msg"] stringByAppendingString:@"[ syn call]"];
}

- (NSString *)die:(NSDictionary *)args
{
    return [(NSString *)[args valueForKey:@"msg"] stringByAppendingString:@"[ syn call]"];
    
}
- (NSString *)go:(NSDictionary *)args
{
    return [(NSString *)[args valueForKey:@"msg"] stringByAppendingString:@"[ syn call]"];
    
}

#pragma mark 常用回调
- (NSString *)go:(NSDictionary *)args  :(void (^)( NSString* _Nullable result))completionHandler {
    if ([self checkNONullAndLengthData:args dictKey:@"url"] && self.nav) {
        completionHandler([self getBackJsonStringWith:@{@"code":@"0"}]);
        
        ZPublicBridgeWebVC *webVC = [[ZPublicBridgeWebVC alloc] init];
        webVC.strUrl = args[@"url"];
        [self.nav.navigationController pushViewController:webVC animated:YES];
    }else{
        completionHandler([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
    return nil;
}

- (NSString *)to:(NSDictionary *)args  :(void (^)( NSString* _Nullable result))completionHandler {
    if ([self checkNONullAndLengthData:args dictKey:@"name"] && self.nav) {
        [self pushTOVC:args[@"name"] pushData:args];
        completionHandler([self getBackJsonStringWith:@{@"code":@"0"}]);
    }else{
        completionHandler([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
    return nil;
}


- (NSString *)die:(NSDictionary *)args  :(void (^)( NSString* _Nullable result))completionHandler {
    if (self.nav) {
        [self.nav.navigationController  popViewControllerAnimated:YES];
        completionHandler([self getBackJsonStringWith:@{@"code":@"0"}]);
    }else{
        completionHandler([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
    return nil;
}



- (NSString *)toast:(NSDictionary *)args :(void (^)( NSString* _Nullable result))completionHandler {
    if ([self checkNONullAndLengthData:args dictKey:@"cont"]) {
        [self showHubMessage:args[@"cont"]];
        completionHandler([self getBackJsonStringWith:@{@"code":@"0"}]);
    }else{
        completionHandler([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
    return nil;
}


//电话
- (NSString *)tel:(NSDictionary *)args  :(void (^)( NSString* _Nullable result))completionHandler {
    if ([self checkNONullAndLengthData:args dictKey:@"num"]) {
        [self callTel:args[@"num"]];
        completionHandler([self getBackJsonStringWith:@{@"code":@"0"}]);
    }else{
        completionHandler([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
    
    return nil;
}

//下载图片
- (NSString *)saveImage:(NSDictionary *)args  :(void (^)( NSString* _Nullable result))completionHandler {
    if ([self checkNONullAndLengthData:args dictKey:@"url"]) {
        [self saveImageToNative:args[@"url"]];
        completionHandler([self getBackJsonStringWith:@{@"code":@"0"}]);
    }else{
        completionHandler([self getBackJsonStringWith:@{@"code":@"1"}]);
    }
    
    return nil;
}

#pragma mark 调用web函数
- (void)callWebBack:(DWKwebview *)webview {
    [webview callHandler:@"back"
                arguments:nil
        completionHandler:^(NSString *  value){
            NSLog(@"%@",value);
        }];
}

- (void)callWebReload:(DWKwebview *)webview {
    [webview callHandler:@"reload"
               arguments:nil
       completionHandler:^(NSString *  value){
           NSLog(@"%@",value);
       }];
}

#pragma mark 常用工具方法
//返回json数据格式
- (NSString *)getBackJsonStringWith:(NSDictionary *)backDict {
    
    if ([JSBUtil objToJsonString:backDict]) {
        return [JSBUtil objToJsonString:backDict];
    }
    return [JSBUtil objToJsonString:@{@"code":@"1"}];
}

//返回失败json数据格式
- (NSString *)getErrorBackJsonStringWith:(NSDictionary *)backDict {
    
    return [JSBUtil objToJsonString:@{@"code":@"1"}];
}

- (BOOL)checkNONullAndLengthData:(id)dict dictKey:(NSString *)key {
    
    if (dict && [dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:key] && ![dict[key] isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (void)callTel:(NSString *)tel {
    double version = [[[UIDevice currentDevice] systemVersion] doubleValue];
    if (version > 10.1) {
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return;
    }
}

- (NSString *)objToJsonString:(id)dict {
    
    return [JSBUtil objToJsonString:dict];
}

- (id)jsonStringToObject:(NSString *)jsonString {
    
    return [JSBUtil jsonStringToObject:jsonString];
}

- (void)showHubMessage:(NSString *)hubMessage {
    [[ZPublicManager shareInstance] showHudMessage:hubMessage];
}

- (void)saveImageToNative:(NSString *)urlString {
    [[ZPublicManager shareInstance] showHud];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSString *msg = nil ;
    [[ZPublicManager shareInstance] hideHud];
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    [[ZPublicManager shareInstance] showHudMessage:msg];
}


- (void)pushTOVC:(NSString *)typeName pushData:(NSDictionary *)args {
    if ([typeName isEqualToString:@"goods"] && [args objectForKey:@"param"]  && [args[@"param"] isKindOfClass:[NSDictionary class]]) {
        if ([self checkNONullAndLengthData:args[@"param"] dictKey:@"goods_id"]) {
            //商品详情页
            //            HNGoodInfoVC *giVC = [[HNGoodInfoVC alloc] init];
            //            giVC.goodId = args[@"param"][@"goods_id"];
            //            [self.nav.navigationController pushViewController:giVC animated:YES];
        }
    }else if([typeName isEqualToString:@"home"]){
        [self.nav.navigationController popToRootViewControllerAnimated:YES];
    }
}


//选择照片  imageScale = 1
- (void)selectedImage:(CGSize)size completeBlock:(void(^)(UIImage *))complete{
    __weak typeof(self) weakSelf = self;
    
    [self actionSheetWithLibrary:^{
        [weakSelf.imagePicker libraryPhotoWithController:self.nav cropSize:size imageScale:1 isCircular:false formDataBlock:^(UIImage *image, ZYFormData *formData) {
            complete(image);
        }];
    } cameraBlock:^{
        [weakSelf.imagePicker cameraPhotoWithController:self.nav cropSize:size imageScale:1 isCircular:false formDataBlock:^(UIImage *image, ZYFormData *formData) {
            complete(image);
        }];
    }];
}


- (void)actionSheetWithLibrary:(void(^)(void))block1 cameraBlock:(void(^)(void))block2 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !block1?:block1();
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !block2?:block2();
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:libraryAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    [self.nav presentViewController:alert animated:true completion:nil];
}

//上传图片

- (void)uploadImage:(UIImage *)image url:(NSString *)url cameraBlock:(void(^)(id,NSError *))complete {
    [ZBaseNetWorkManager postImage:url params:@{@"headImage":image} completionHandler:^(id info, NSError *error) {
        complete(info,error);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alipay" object:nil];
}
@end
