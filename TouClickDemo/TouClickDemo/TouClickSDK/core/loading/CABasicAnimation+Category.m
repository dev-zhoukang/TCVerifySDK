//
//  TCViewController.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "CABasicAnimation+Category.h"

@implementation CABasicAnimation (Category)

+ (CABasicAnimation *)zk_opacityForeverAnimation:(NSTimeInterval)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1.f;
    animation.toValue = @0;
    animation.autoreverses = YES; //
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //定义动画的样式 渐入式   timingFunction 控制动画运行的节奏
    animation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

@end
