//
//  TCVerifyModel.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCVerifyModel : NSObject

@property (nonatomic, copy) NSString *checkAddr;
@property (nonatomic, copy) NSString *token;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
