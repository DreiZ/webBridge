//
//  LGWaitingAnnimation.m
//  hntx
//
//  Created by zzz on 2018/1/28.
//  Copyright © 2018年 zoomwoo. All rights reserved.
//

#import "LGWaitingAnnimation.h"

static LGWaitingAnnimation *waitting_m;

@interface LGWaitingAnnimation()
@property (nonatomic, strong) UILabel *hintLabel;
@end

@implementation LGWaitingAnnimation


+(LGWaitingAnnimation *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        waitting_m = [[LGWaitingAnnimation alloc] init];
    });
    return waitting_m;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.frame = [UIScreen mainScreen].bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 90)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    view.backgroundColor = [UIColor darkGrayColor];
    view.alpha = 0.8;
    view.center = self.center;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 15, 30, 30)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator startAnimating];
    [view addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(16);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 130, 30)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = @"";
    _hintLabel = lab;
    [view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(view.mas_top).offset(53);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:view];
}

- (void)show
{
    _hintLabel.text = @"";
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(180 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)showWithMsg:(NSString *)title {
    self.hintLabel.text = title;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(180 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)updateTitle:(NSString *)title {
    [self.hintLabel setText:title];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
@end

