//
//  TCViewController.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKLoading.h"

static ZKLoading *loadView;

@implementation ZKLoading

- (instancetype)initWithFrame:(CGRect)frame
                         type:(ZKLoadingType)type {

    if (self == [super initWithFrame:frame]) {
        
        switch (type) {
            case ZKLoadingCircle:
                [self creatAnimation];
                break;
            case ZKLoadingDot:
                [self createDotAnimation];
                break;
            case ZKLoadingLine:
                [self createLineAnimation];
                break;
                
            case ZKLoadingCircleJoin:
                [self creatCircleJoinAnimation];
                break;
                
            default:
                break;
        }
    }

    return self;
}

#pragma mark - public

+ (void)showDotView:(UIView *)view {
    loadView = [[ZKLoading alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) type:ZKLoadingDot];
    loadView.backgroundColor = [UIColor whiteColor];
    loadView.center = view.center;
    [view addSubview:loadView];
}

+ (void)showLineView:(UIView *)view {

    loadView = [[ZKLoading alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) type:ZKLoadingLine];
    loadView.backgroundColor = [UIColor whiteColor];
    loadView.center = view.center;
    [view addSubview:loadView];
}

+ (void)showCircleView:(UIView *)view {

    if (loadView) {
        return;
    }
    
    loadView = [[ZKLoading alloc] initWithFrame:CGRectMake(-1.f, -1.f, CGRectGetWidth(view.frame)+2.f, CGRectGetHeight(view.frame)+2.f) type:ZKLoadingCircle];
    loadView.layer.cornerRadius = 5.f;
    loadView.backgroundColor = [UIColor whiteColor];
    [view addSubview:loadView];
}

+ (void)showCircleJoinView:(UIView *)view {
    loadView = [[ZKLoading alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) type:ZKLoadingCircleJoin];
    loadView.backgroundColor = [UIColor whiteColor];
    loadView.center = view.center;
    [view addSubview:loadView];
}

+ (void)hide {
    
    if (!loadView) {
        return;
    }
    [UIView animateWithDuration:.25 animations:^{
        loadView.alpha = 0;
    } completion:^(BOOL finished) {
        [loadView removeFromSuperview];
        loadView = nil;
    }];
}

#pragma mark - private method

- (void)creatAnimation {
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        =  self.center;
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:replicatorLayer];
    
    CALayer *dot        = [CALayer layer];
    dot.bounds          = CGRectMake(0, 0, 10, 10);
    dot.position        = CGPointMake(50, 20);
    dot.backgroundColor = [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:1].CGColor;
    dot.cornerRadius    = 5;
    dot.masksToBounds   = YES;
    
    [replicatorLayer addSublayer:dot];
    
    CGFloat count                     = 10.0;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2 * M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = .8;
    animation.fromValue   = @1;
    animation.toValue     = @0.01;
    animation.repeatCount = MAXFLOAT;
    [dot addAnimation:animation forKey:nil];
    
    replicatorLayer.instanceDelay = animation.duration / count;
    
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}
- (void)creatCircleJoinAnimation {
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        =  self.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    
    [self.layer addSublayer:replicatorLayer];
    
    CALayer *dot        = [CALayer layer];
    dot.bounds          = CGRectMake(0, 0, 10, 10);
    dot.position        = CGPointMake(50, 20);
    dot.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6].CGColor;
    dot.cornerRadius    = 5;
    dot.masksToBounds   = YES;
    
    [replicatorLayer addSublayer:dot];
    
    CGFloat count                     = 100.0;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2* M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0.1;
    animation.repeatCount = MAXFLOAT;
    [dot addAnimation:animation forKey:nil];
    
    replicatorLayer.instanceDelay = 1.0/ count;
    
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)createLineAnimation {
   
    //1.创建relicatorLayer对象
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = self.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.masksToBounds   = YES;
    
    [self.layer addSublayer:replicatorLayer];
    
    CGFloat count = 4;
    CGFloat lineH = 50;
    CGFloat lineMarginX = 30;
    CGFloat lineInter = 10;
    CGFloat lineW = 5;
    
    //2.创建CALayer对象
    CALayer *lineLayer        = [CALayer layer];
    lineLayer.bounds          = CGRectMake(0, 0, lineW, lineH);
    lineLayer.position        = CGPointMake(lineMarginX, replicatorLayer.frame.size.height - 30);
    lineLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6].CGColor;
    
    [replicatorLayer addSublayer:lineLayer];
    
    
    replicatorLayer.instanceCount = count;
    
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(lineInter, 0, 0);
    
    //3.设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.toValue           = @(lineH*0.4);
    animation.duration          = 0.5;
    animation.autoreverses      = YES;
    animation.repeatCount       = MAXFLOAT;
    
    [lineLayer addAnimation:animation forKey:nil];
    
    replicatorLayer.instanceDelay = 0.5 / count;
}

- (void)createDotAnimation {
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = self.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.masksToBounds   = YES;
    
    [self.layer addSublayer:replicatorLayer];

    CALayer *dotLayer        = [CALayer layer];
    dotLayer.bounds          = CGRectMake(0, 0, 15, 15);
    dotLayer.position        = CGPointMake(15, replicatorLayer.frame.size.height/2 );
    dotLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6].CGColor;
    dotLayer.cornerRadius    = 7.5;
    
    [replicatorLayer addSublayer:dotLayer];
    
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(replicatorLayer.frame.size.width/3, 0, 0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 0.8;
    animation.fromValue   = @1;
    animation.toValue     = @0;
    animation.repeatCount = MAXFLOAT;
    [dotLayer addAnimation:animation forKey:nil];
    
    replicatorLayer.instanceDelay = 0.8/3;

    dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
}

@end
