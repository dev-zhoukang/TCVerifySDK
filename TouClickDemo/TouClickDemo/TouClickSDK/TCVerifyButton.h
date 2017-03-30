//
//  TCVerifyButton.h
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCVerifyButton : UIButton

- (void)verifyBtnWithCompletion:(void (^ __nullable)(NSDictionary * __nullable cbData))completion;

@end
