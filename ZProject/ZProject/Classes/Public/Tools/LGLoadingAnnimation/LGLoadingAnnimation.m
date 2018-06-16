//
//  LGLoadingAnnimation.m
//
//  Created by smallsea on 15/5/26.
//  Copyright (c) 2015年 smallsea. All rights reserved.
//


#define L_WIDTH [UIScreen mainScreen].bounds.size.width
#define L_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kSpotBackViewWidth 140.
#define kSpotBackViewHeight 60.
#define radios 25/640.*[UIScreen mainScreen].bounds.size.width
#define layerR 18/750.*[UIScreen mainScreen].bounds.size.width
#define dura   0.5
#define kBounceSpotAnimationDuration 0.6

#define kTimeout 30
#import "LGLoadingAnnimation.h"

static LGLoadingAnnimation *loading_m;
@interface LGLoadingAnnimation()<CAAnimationDelegate>

//@property (nonatomic, strong) UIImageView  *loadImgV;
//@property (nonatomic, strong) UIImageView  *lgImgV;
@property (nonatomic,strong) CALayer *spotLayer;
@property (nonatomic,strong) CAReplicatorLayer *spotRelicatorlayer;
@property (nonatomic,strong) UIView *spotBackView;
@end
@implementation LGLoadingAnnimation
{
    UIView *_bgView;
    NSTimer *_timer;
    NSUInteger times;
    
    
    CGPoint cirleCenter;
    NSMutableArray *layersArr;
}
+(LGLoadingAnnimation *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loading_m = [[LGLoadingAnnimation alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return loading_m;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        /**
         UIImage *loadImg = [UIImage imageNamed:@"1"];
         UIImage *lgImg = [UIImage imageNamed:@"LG"];
         
         
         
         self.frame = CGRectMake((L_WIDTH-loadImg.size.width/2.)/2., (L_HEIGHT-loadImg.size.height/2.)/2., loadImg.size.width/2., loadImg.size.height/2.);
         
         self.loadImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loadImg.size.width/2., loadImg.size.height/2.)];
         self.loadImgV.image = loadImg;
         
         self.lgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, lgImg.size.width/2., lgImg.size.height/2.)];
         self.lgImgV.center = self.loadImgV.center;
         
         self.lgImgV.image = lgImg;
         
         self.backgroundColor = [UIColor clearColor];
         
         
         
         [self addSubview:self.loadImgV];
         [self addSubview:self.lgImgV];
         */
        [self initAnimationView];
        self.isShow = NO;
        
        
        // 计时器
        times = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(timeGo:) userInfo:nil repeats:YES];
      
        
    }
    
    return self;

}




/**
 - (void) addAnnimation
 {
 CABasicAnimation* rotationAnimation;
 rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
 rotationAnimation.duration = 1;
 rotationAnimation.cumulative = YES;
 rotationAnimation.repeatCount = 30;
 
 [self.loadImgV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
 
 
 }
 */



- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}





- (void)show
{
    self.isShow = YES;
    UIViewController *rootVC = [self appRootViewController];
    
    //[self addAnnimation];
    
    [self steupAnimation];
    [rootVC.view addSubview:self];
    
    times = 0;
    [_timer fire];
    
    
}

-(void) newShowInTheView:(UIView *)showView
{
//    
//    UIViewController *topVC = vc;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    
    //[self addAnnimation];
   
//   dispatch_async(dispatch_get_main_queue(), ^{
    if (![showView isKindOfClass:[self class]]) {
        self.isShow = YES;
        [self steupAnimation];
        
        [showView addSubview:self];
        //    });
        UIView *superView = self.superview;
        if (superView) {
            CGFloat backCenterY = superView.height/2.;
            _spotBackView.centerY = backCenterY;
        }
        times = 0;
        [_timer setFireDate:[NSDate distantPast]];
    }

}

-(void) newShowInTheView:(UIView *)showView offsetY:(CGFloat)offsetY
{
    //
    //    UIViewController *topVC = vc;
    //    while (topVC.presentedViewController) {
    //        topVC = topVC.presentedViewController;
    //    }
    //
    //[self addAnnimation];
    self.isShow = YES;
    [self steupAnimation];
    //   dispatch_async(dispatch_get_main_queue(), ^{
    [showView addSubview:self];
    //    });
    UIView *superView = self.superview;
    if (superView) {
        CGFloat backCenterY = superView.height/2. + offsetY;
        _spotBackView.centerY = backCenterY;
    }
    times = 0;
    [_timer setFireDate:[NSDate distantPast]];
}



- (void)hide
{
    
    [_spotLayer removeAllAnimations];
    [self.layer removeAllAnimations];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
    self.isShow = NO;
    [_timer setFireDate:[NSDate distantFuture]];

    
}


- (void) timeGo:(id)sender
{
    times += 1;
    
    if(!self.isShow)
    {
        [self hide];
    }
    
    if (times > kTimeout) {
        [_timer setFireDate:[NSDate distantFuture]];
        if (self.isShow) {
            [self hide];
        }
    }
}


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(newSuperview.frame.origin.x , newSuperview.frame.origin.y, newSuperview.frame.size.width, newSuperview.frame.size.height)];
    
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
//    pan.delegate = self;
    [_bgView addGestureRecognizer:pan];
    dispatch_async(dispatch_get_main_queue(), ^{
        [newSuperview addSubview:_bgView];
    });
  
}

-(void)panGes:(UIPanGestureRecognizer *)pan
{
    
}

#pragma mark ------------- new animation -------------
- (void) initAnimationView
{
    _spotBackView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, (kSpotBackViewWidth/750.)*kWindowW, (kSpotBackViewHeight/750.)*kWindowW)];
    _spotBackView.center = self.center;
    [self addSubview:_spotBackView];
    
    /**
     modify 2017 0215
     _spotLayer = [CAShapeLayer layer];
     _spotLayer.cornerRadius = layerR/2.;
     _spotLayer.masksToBounds = YES;
     UIColor *col = kHN_MainColor;
     _spotLayer.backgroundColor = col.CGColor;
     _spotLayer.frame = CGRectMake(0, kSpotBackViewHeight/2.0, layerR, layerR);
     
     _spotRelicatorlayer = [CAReplicatorLayer layer];
     [_spotRelicatorlayer addSublayer:_spotLayer];
     _spotRelicatorlayer.instanceCount = 4;
     _spotRelicatorlayer.instanceDelay = 0.4/5;
     _spotRelicatorlayer.instanceTransform = CATransform3DMakeTranslation(layerR/3.*5.,0,0);
     [self.spotBackView.layer addSublayer:_spotRelicatorlayer];
     [_spotBackView setHidden:YES];
     */
    
    _spotRelicatorlayer = [CAReplicatorLayer layer];
    _spotRelicatorlayer.frame = CGRectMake(0, 0, kSpotBackViewHeight, kSpotBackViewHeight);
    _spotRelicatorlayer.position = CGPointMake(0,0);
    _spotRelicatorlayer.backgroundColor = [UIColor clearColor].CGColor;
    _spotRelicatorlayer.centerX = _spotBackView.width/2.0;
    [_spotBackView.layer addSublayer:_spotRelicatorlayer];

    CGFloat radius = kSpotBackViewHeight/7;
    self.spotLayer = [CALayer layer];
    self.spotLayer.bounds = CGRectMake(0, 0, radius, radius);
    self.spotLayer.position = CGPointMake(radius/2, kSpotBackViewHeight/2);
    self.spotLayer.cornerRadius = radius/2;
    self.spotLayer.backgroundColor = [UIColor redColor].CGColor;
    self.spotLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
    
    [_spotRelicatorlayer addSublayer:self.spotLayer];

    
    NSInteger numOfDot = 4;
    _spotRelicatorlayer.instanceCount = numOfDot;
    _spotRelicatorlayer.instanceTransform = CATransform3DMakeTranslation(kSpotBackViewHeight/5, 0, 0);
    _spotRelicatorlayer.instanceDelay = kBounceSpotAnimationDuration/numOfDot;

}



- (void) steupAnimation
{
    
    [_spotBackView setHidden:NO];
    [_spotLayer addAnimation:[self cyclingSpotAnimation] forKey:@"positionAnimation"];
    
//    int i = 0;
//    for (CAShapeLayer *la in layersArr) {
//        [la addAnimation:[self createAnimationWithDuration:dura delay:dura/4.*i] forKey:@"m"];
//        la.timeOffset = dura*2;
//        i++;
//    }
//    
    
    
}


- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.delegate = self;
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    anim.autoreverses = YES;
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime()+delay;
    anim.removedOnCompletion = NO;
    anim.repeatCount = INFINITY;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    
    return anim;
}

/**
 modify 2017 0215
 */
//-(CAKeyframeAnimation *)animationForBouncy
//{
//    float pointCenterY = kSpotBackViewHeight/2.0;
//    float downPointDownY = 0;
//    
//    CAKeyframeAnimation *pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
//    pointAnimation.beginTime = CACurrentMediaTime();
////    pointAnimation.values = @[[NSNumber numberWithFloat:pointCenterY] ,[NSNumber numberWithFloat:downPointDownY],[NSNumber numberWithFloat:downPointDownY],[NSNumber numberWithFloat:pointCenterY],[NSNumber numberWithFloat:pointCenterY]];
////    pointAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.33],[NSNumber numberWithFloat:0.53],[NSNumber numberWithFloat:0.75],[NSNumber numberWithFloat:1.0]];
//    
//    pointAnimation.values = @[[NSNumber numberWithFloat:pointCenterY] ,[NSNumber numberWithFloat:downPointDownY],[NSNumber numberWithFloat:pointCenterY],[NSNumber numberWithFloat:pointCenterY]];
//    pointAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.33],[NSNumber numberWithFloat:0.63],[NSNumber numberWithFloat:1.0]];
//    pointAnimation.removedOnCompletion = YES;
//    pointAnimation.repeatCount = MAXFLOAT;
//    pointAnimation.duration = 0.9;
//    return pointAnimation;
//    
//}
-(CABasicAnimation *)cyclingSpotAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.2;
    animation.toValue = @1;
    animation.duration = kBounceSpotAnimationDuration;
    animation.autoreverses = YES;
    animation.repeatCount = CGFLOAT_MAX;
    return animation;
}








@end
