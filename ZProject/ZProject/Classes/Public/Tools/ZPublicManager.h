//
//  ZPublicManager.h
//  ZProject
//
//  Created by zzz on 2018/6/6.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+Block.h"

@interface ZPublicManager : NSObject
+ (ZPublicManager *)shareInstance;
/** 清理缓存 */
- (void)cleanCachesVC:(UIViewController *)vc completionHandler:(void (^)(NSString *))completionHandler;
/** 遍历文件夹获得文件夹大小，返回多少M */
- (float )folderSizeAtPath:(NSString*) folderPath;

-(void)showHud;
-(void)hideHud;
-(void)showMessage:(NSString *)message;
-(void)showMessageBtnBlock:(NSString *)message
                    hander:(UIAlertViewCallBackBlock)handler
         otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
-(void)showMessageBlock:(NSString *)message
                 hander:(UIAlertViewCallBackBlock)handler;
-(void)showMessageTitle:(NSString *)titleStr
                message:(NSString *)message
                 hander:(UIAlertViewCallBackBlock)handler
           cancelButton:(NSString *)cancelStr
      otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
-(void)showHudMessage:(NSString *)message;
-(void)showHudMessage:(NSString *)message yOffset:(CGFloat)yOffset;
-(void)showHudMessage:(NSString *)message DelayTime:(double)delaytime;
-(void)showHudErrorMessage:(NSString *)message;

@end
