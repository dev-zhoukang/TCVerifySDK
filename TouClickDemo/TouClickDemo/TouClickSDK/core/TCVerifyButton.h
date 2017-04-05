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

/**
 验证通过后，可设置验证按钮为成功状态 或 待验证状态
 
 @param success true: 成功状态  false: 待验证状态
 */
- (void)setSucceeStyle:(BOOL)success;

@end
