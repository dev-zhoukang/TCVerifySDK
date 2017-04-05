//
//  TCViewController.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZKLoadingType) {
    ZKLoadingCircle,
    ZKLoadingDot,
    ZKLoadingLine,
    ZKLoadingCircleJoin,
};

@interface ZKLoading : UIView

+ (void)showCircleView:(UIView *)view;

+ (void)showDotView:(UIView *)view;

+ (void)showLineView:(UIView *)view;

+ (void)showCircleJoinView:(UIView *)view;

+ (void)hide;

@end
