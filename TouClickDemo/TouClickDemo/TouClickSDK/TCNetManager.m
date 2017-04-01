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
          callback:(void (^)(BOOL success, NSDictionary *res))callback {
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
            return;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!jsonStr.length) {
            NSLog(@"jsonStr 为空");
            !callback?:callback(false, nil);
            return;
        }
        
        NSString *subStr = [jsonStr componentsSeparatedByString:@"("][1];
        subStr = [subStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSData *jsonData = [subStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !callback?:callback(true, dict);
        });
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *item in dict[@"data"]) {
            [images addObject:dict[@"data"][item]];
        }
    }];
    [task resume];
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

@end
