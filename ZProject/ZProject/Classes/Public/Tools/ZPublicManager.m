//
//  ZPublicManager.m
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZPublicManager.h"
#import "LGLoadingAnnimation.h"
#import "HNAlertAction.h"
#import "AppDelegate.h"

@interface ZPublicManager ()
{
    LGLoadingAnnimation *loading;
}
@end

@implementation ZPublicManager
+ (ZPublicManager *)shareInstance {
    static ZPublicManager *publicManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        publicManager = [[ZPublicManager alloc] init];
    });
    return publicManager;
}


/** 清理缓存 */
- (void)cleanCachesVC:(UIViewController *)vc completionHandler:(void (^)(NSString *))completionHandler {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *files = [manager subpathsAtPath:cachePath];
            for (NSString *p in files) {
                NSError *error = nil;
                NSString *path = [cachePath stringByAppendingPathComponent:p];
                if ([manager fileExistsAtPath:path]) {
                    [manager removeItemAtPath:path error:&error];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(@"清理成功");
            });
        });
        
        [self showSuccessWithMsg:@"清理成功"];
    }];
    [ac addAction:cancelAction];
    [ac addAction:ensureAction];
    [vc presentViewController:ac animated:YES completion:nil];
}

- (long long)fileSizeAtPath:(NSString*) filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/** 遍历文件夹获得文件夹大小，返回多少M */
- (float )folderSizeAtPath:(NSString*) folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


#pragma mark 消息提示

-(void)showHudInView:(UIView*)showView
{
    
    if (loading && loading.isShow) {
        //        [loading hide];
        return;
    }
    loading = [LGLoadingAnnimation shareManager];
    [loading newShowInTheView:showView];
}

-(void)showHudInView:(UIView*)showView offsetY:(CGFloat)offsetY {
    if (loading && loading.isShow) {
        //        [loading hide];
        return;
    }
    loading = [LGLoadingAnnimation shareManager];
    [loading newShowInTheView:showView offsetY:offsetY];
}

-(void)hideHud
{
    if (loading && loading.isShow) {
        [loading hide];
    }
}
-(void)showHud
{
    UIViewController *topVc = [[UIApplication sharedApplication].delegate window].rootViewController;
    while (topVc.presentedViewController) {
        topVc = topVc.presentedViewController;
    }
    
    [self showHudInView:topVc.view];
    
}


-(void)showMessage:(NSString *)message
{
    [self showMessageBtnBlock:message  hander:nil otherButtonTitles:nil];
}

-(void)showHudMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window]  animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.margin = 10.f;
    hud.yOffset = -50.0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

-(void)showHudMessage:(NSString *)message yOffset:(CGFloat)yOffset{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window]  animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.margin = 10.f;
    hud.yOffset = yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];

}

-(void)showHudMessage:(NSString *)message DelayTime:(double)delaytime
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window]  animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.margin = 10.f;
    hud.yOffset = -50.0;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:delaytime];
}
-(void)showHudErrorMessage:(NSString *)message
{
    [self showHudMessage:message];
}


-(void)showMessageBtnBlock:(NSString *)message
                    hander:(UIAlertViewCallBackBlock)handler
         otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION
{
    [self showMessageTitle:@"提示" message:message hander:handler cancelButton:@"确定" otherButtonTitles:otherButtonTitles, nil];
}

-(void)showMessageBlock:(NSString *)message
                 hander:(UIAlertViewCallBackBlock)handler
{
    [self showMessageBtnBlock:message  hander:handler otherButtonTitles:nil];
}

-(void)showMessageTitle:(NSString *)titleStr
                message:(NSString *)message
                 hander:(UIAlertViewCallBackBlock)handler
           cancelButton:(NSString *)cancelStr
      otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION
{
    
    if(message&&[message isKindOfClass:[NSString class]])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:message preferredStyle:UIAlertControllerStyleAlert];
        HNAlertAction *cancelAction = [HNAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleDefault withTag:0 handler:^(UIAlertAction *action){
            HNAlertAction *hnAction = (HNAlertAction*)action;
            if(handler)
            {
                handler(hnAction.alertTag);
            }
            
        }];
        
        [alertController addAction:cancelAction];
        va_list args;
        va_start(args, otherButtonTitles); // scan for arguments after firstObject.
        int alertTag=1;
        // get rest of the objects until nil is found
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            HNAlertAction *okAction = [HNAlertAction actionWithTitle:str style:UIAlertActionStyleDefault withTag:alertTag handler:^(UIAlertAction *action){
                HNAlertAction *hnAction = (HNAlertAction*)action;
                if(handler)
                {
                    handler(hnAction.alertTag);
                }
                
            }];
            alertTag++;
            [alertController addAction:okAction];
        }
        
        va_end(args);
        
        [[self appRootViewController] presentViewController:alertController animated:YES completion:^{
            ;
        }];
    }
    
}
#pragma mak 获取当前VC
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [AppDelegate App].tb;
    
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end
