//
//  TCVerifyUtil.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCVerifyUtil : NSObject

+ (UIImage *)generateImageWithBase64Dict:(NSDictionary *)dict;

+ (NSString *)getSID;

@end
