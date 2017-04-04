//
//  TCCheckModel.m
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCCheckModel.h"

@implementation TCCheckModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    TCCheckModel *model = [TCCheckModel new];
    model.sid = dict[@"sid"];
    return model;
}

@end
