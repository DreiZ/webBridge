//
//  LGLoadingAnnimation.h
//
//  Created by smallsea on 15/5/26.
//  Copyright (c) 2015年 smallsea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGLoadingAnnimation : UIView



@property (nonatomic, assign) BOOL isShow;

+(LGLoadingAnnimation *)shareManager;
-(void) newShowInTheView:(UIView *)showView;
-(void) newShowInTheView:(UIView *)showView offsetY:(CGFloat)offsetY;
- (void) show;
- (void) hide;
@end
