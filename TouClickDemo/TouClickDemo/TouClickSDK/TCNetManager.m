//
//  TCNetManager.m
//  TouClickDemo
//
//  Created by ZK on 2017/4/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCNetManager.h"

@interface TCNetManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation TCNetManager

+ (instancetype)shareInstance {
    static TCNetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TCNetManager alloc] init];
    });
    return manager;
}

- (void)getRequest:(NSString *)urlStr
            params:(NSDictionary *)params
          callback:(void (^)(NSError *error, NSDictionary *res))callback {
    
    NSURL *url = nil;
    if ([urlStr isKindOfClass:[NSURL class]]) {
        url = (NSURL *)urlStr;
    }
    else {
        url = [NSURL URLWithString:urlStr];
    }
    _session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败 ==> %@", error);
            !callback?:callback(error, nil);
            return;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!jsonStr.length) {
            NSLog(@"解析 jsonStr 为空");
            NSError *error = [NSError errorWithDomain:@"com.zk" code:0 userInfo:@{@"message": @"解析 jsonStr 为空"}];
            
            !callback?:callback(error, nil);
            return;
        }
        
        NSString *subStr = [jsonStr componentsSeparatedByString:@"("][1];
        subStr = [subStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSData *jsonData = [subStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !callback?:callback(nil, dict);
        });
    }];
    [task resume];
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

@end
