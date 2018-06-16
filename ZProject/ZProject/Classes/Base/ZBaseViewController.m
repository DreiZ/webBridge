//
//  ZBaseViewController.m
//  ZProject
//
//  Created by zzz on 2018/6/5.
//  Copyright © 2018年 zzz. All rights reserved.
//

#import "ZBaseViewController.h"
#import "WRNavigationBar.h"

@interface ZBaseViewController ()

@end

@implementation ZBaseViewController

+(UINavigationController *)defaultNavi {
    
    ZBaseViewController *basevc = [[ZBaseViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:basevc];
    
    return navi;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
@end
