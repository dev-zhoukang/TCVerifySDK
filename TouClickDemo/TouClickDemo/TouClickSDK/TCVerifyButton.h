//
//  TCVerifyButton.h
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCVerifyButton : UIButton


/**
 验证按钮的 block 回调
 
 @param completion 验证成功返回 token 供用户使用
 */
- (void)verifyCompletion:(void (^ __nullable)( NSString * _Nullable token))completion;

@end
