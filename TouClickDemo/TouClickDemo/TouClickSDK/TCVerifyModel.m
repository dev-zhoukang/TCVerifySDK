//
//  TCVerifyModel.m
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCVerifyModel.h"

@implementation TCVerifyModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    TCVerifyModel *model = [TCVerifyModel new];
    model.checkAddr = dict[@"checkAddress"];
    model.token = dict[@"token"];
    
    return model;
}

@end
