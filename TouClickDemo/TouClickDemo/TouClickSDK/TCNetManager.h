//
//  TCNetManager.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCNetManager : NSObject

+ (instancetype)shareInstance;

- (void)getRequest:(NSString *)urlStr
            params:(NSDictionary *)params
          callback:(void (^)(NSError *error, NSDictionary *res))callback ;

@end
