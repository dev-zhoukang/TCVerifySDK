//
//  TCVerifyView.h
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCVerifyModel;

@interface TCVerifyView : UIView

+ (instancetype)showWithCompletion:(void (^)(TCVerifyModel *verifyModel))completion;

@end
