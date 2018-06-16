//
//  HNAlertAction.m
//  hntx
//
//  Created by Viking on 16/7/9.
//  Copyright © 2016年 zoomwoo. All rights reserved.
//

#import "HNAlertAction.h"
HNAlertAction* alertView = nil;
@implementation HNAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style withTag:(NSInteger)alertTag handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    alertView  = [super actionWithTitle:title style:style handler:handler];
    if (alertTag==0) {
        [alertView setValue:kMainColor forKey:@"_titleTextColor"];
    }
    else
    {
        [alertView setValue:kMainColor forKey:@"_titleTextColor"];
    }
    
    alertView.alertTag = alertTag;
    return alertView;
}

@end
