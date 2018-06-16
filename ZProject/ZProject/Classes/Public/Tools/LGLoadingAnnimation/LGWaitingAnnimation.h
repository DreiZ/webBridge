//
//  LGWaitingAnnimation.h
//  hntx
//
//  Created by zzz on 2018/1/28.
//  Copyright © 2018年 zoomwoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGWaitingAnnimation : UIView
+(LGWaitingAnnimation *)shareManager;
- (void) updateTitle:(NSString *)title;
- (void) showWithMsg:(NSString *)title;
- (void) show;
- (void) hide;
@end

