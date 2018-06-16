//
//  AppDelegate.h
//  ZProject
//
//  Created by zzz on 2018/6/5.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBaseTabBarController.h"
#import "ZPublicBridgeWebVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZBaseTabBarController *tabBarController;
@property (strong, nonatomic) ZPublicBridgeWebVC *tb;
+(AppDelegate *)App;
@end

