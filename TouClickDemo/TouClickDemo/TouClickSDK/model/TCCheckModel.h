//
//  TCCheckModel.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCheckModel : NSObject

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *warning;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
