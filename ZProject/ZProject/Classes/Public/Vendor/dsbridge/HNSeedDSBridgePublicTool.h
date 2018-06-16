//
//  HNSeedDSBridgePublicTool.h
//  hntx
//
//  Created by zww on 17/2/15.
//  Copyright © 2017年 zoomwoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DWKwebview;
@interface HNSeedDSBridgePublicTool : NSObject
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, weak) UIViewController *nav;
@property(nonatomic, strong) void (^paySuccess)(NSString *);
+ (instancetype)shareSeedDSBridgeManager;


+ (instancetype)shareSeedDSBridgeManagerWithNav:(UIViewController *)nav;

- (void)callWebBack:(DWKwebview *)webview;

- (void)callWebReload:(DWKwebview *)webview;

@end
