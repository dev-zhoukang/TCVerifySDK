//
//  TCVerifyTabbar.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TCVerifyTypeTXPIC, // 图文验证
    TCVerifyTypeIcon,  // 图标验证
} TCVerifyType;

@interface TCVerifyTabbar : UIView

+ (instancetype)showTabbarOnView:(UIView *)view;

@end
