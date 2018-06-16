//
//  ZBaseTabBarController.m
//  ZProject
//
//  Created by zzz on 2018/6/5.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZBaseTabBarController.h"
#import "ZBaseViewController.h"

@interface ZBaseTabBarController ()

@end

@implementation ZBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewControllers];
}


- (void)setupViewControllers {
    UINavigationController *navi0 = [ZBaseViewController defaultNavi];
    UINavigationController *navi1 = [ZBaseViewController defaultNavi];
    UINavigationController *navi2 = [ZBaseViewController defaultNavi];
    UINavigationController *vc3 = [ZBaseViewController defaultNavi];
    
    [self customTabBarForController];
    [self setViewControllers:@[navi0,navi1,navi2,vc3]];
}

- (void)customTabBarForController{
    NSDictionary *dict0 = @{CYLTabBarItemTitle:@"首页",
                            CYLTabBarItemImage:@"news",
                            CYLTabBarItemSelectedImage:@"newsblue"};
    NSDictionary *dict1 = @{CYLTabBarItemTitle:@"图文",
                            CYLTabBarItemImage:@"live",
                            CYLTabBarItemSelectedImage:@"liveblue"};
    NSDictionary *dict2 = @{CYLTabBarItemTitle:@"视频",
                            CYLTabBarItemImage:@"market",
                            CYLTabBarItemSelectedImage:@"marketblue"};
    NSDictionary *dict3 = @{CYLTabBarItemTitle:@"我的",
                            CYLTabBarItemImage:@"my",
                            CYLTabBarItemSelectedImage:@"myblue"};
    NSArray *tabBarItemsAttributes = @[dict0,dict1,dict2,dict3];
    self.tabBarItemsAttributes = tabBarItemsAttributes;
}
@end
