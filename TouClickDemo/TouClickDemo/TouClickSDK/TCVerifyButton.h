//
//  TCVerifyButton.h
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCVerifyButton : UIButton

- (void)verifyCompletion:(void (^ __nullable)( NSString * _Nullable token))completion;

@end
