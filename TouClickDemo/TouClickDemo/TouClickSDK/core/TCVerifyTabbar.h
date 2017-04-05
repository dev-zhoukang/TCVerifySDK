//
//  TCVerifyTabbar.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCVerifyTabbar : UIView

/**
 添加到指定视图上 不需设置 frame, 自动布局到父视图底部

 @param view superview
 @param callback 选择类型后的回调函数
 @return 实例对象
 */
+ (instancetype)showTabbarOnView:(UIView *)view
              selectTypeCallback:(void (^)(NSString *ct))callback;
+ (instancetype)showTabbarOnView:(UIView *)view;

/**
 获取当前用户选择的验证类型
 
 @return 验证类型 如: 图文验证 @"13"
 */
+ (NSString *)getSelectdType;

@end
