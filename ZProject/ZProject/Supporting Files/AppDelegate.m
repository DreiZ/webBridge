//
//  AppDelegate.m
//  ZProject
//
//  Created by zzz on 2018/6/5.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "AppDelegate.h"
#import "ZPublicBridgeWebVC.h"
#import "ZPublicWebVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = self.tb;
    // 欢迎视图
   
    return YES;
}

- (ZPublicBridgeWebVC *)tb {
    if(_tb == nil) {
        _tb = [[ZPublicBridgeWebVC alloc] init];
    }
    return _tb;
}

+(AppDelegate *)App {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (UIWindow *)window {
    if(_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (ZBaseTabBarController *)tabBarController {
    if(_tabBarController == nil) {
        _tabBarController = [[ZBaseTabBarController alloc] init];
    }
    return _tabBarController;
}
@end
