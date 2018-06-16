//
//  HNAlertAction.h
//  hntx
//
//  Created by Viking on 16/7/9.
//  Copyright © 2016年 zoomwoo. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface HNAlertAction : UIAlertAction
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style withTag:(NSInteger)alertTag handler:(void (^ __nullable)(UIAlertAction *action))handler;
@property(nonatomic) NSInteger alertTag;
@end
NS_ASSUME_NONNULL_END
