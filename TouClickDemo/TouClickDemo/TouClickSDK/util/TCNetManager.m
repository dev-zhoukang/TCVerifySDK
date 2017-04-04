//
//  TCNetManager.m
//  TouClickDemo
//
//  Created by ZK on 2017/4/1.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCNetManager.h"
#import "TCGlobalHeader.h"

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
    
    NSCAssert([urlStr isKindOfClass:[NSString class]], @"urlStr must be kind of string");
    
    NSString *queryStr = [self generateQueryStrWithParams: params];
    NSString *fullUrlStr = urlStr.copy;
    fullUrlStr = [urlStr stringByAppendingString:queryStr];
    
    NSURL *url = [NSURL URLWithString:fullUrlStr];
    
    _session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            DLog(@"请求失败 ==> %@", error);
            !callback?:callback(error, nil);
            return;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!jsonStr.length) {
            DLog(@"解析 jsonStr 为空, 重新发起请求");
            NSError *error = [NSError errorWithDomain:@"com.zk" code:0 userInfo:@{@"message": @"解析 jsonStr 为空"}];
            
            !callback?:callback(error, nil);
            [self getRequest:urlStr params:params callback:callback];
            return;
        }
        
        NSString *subStr = [jsonStr componentsSeparatedByString:@"("][1];
        subStr = [subStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        subStr = [subStr stringByReplacingOccurrencesOfString:@";" withString:@""];
        subStr = [self regularJsonString:subStr];
        
        NSData *jsonData = [subStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *myError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        if (![dict isKindOfClass:[NSDictionary class]]) {
            DLog(@"解析 JSON 出错");
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !callback?:callback(nil, dict);
        });
    }];
    [task resume];
}

//把没有双引号和用了单引号的json字符串转化为标准格式字符串;
- (NSString *)regularJsonString:(NSString *)json
{
    // 将没有双引号的替换成有双引号的
    NSString *validString = [json stringByReplacingOccurrencesOfString:@"(\\w+)\\s*:([^A-Za-z0-9_])"
                                                            withString:@"\"$1\":$2"
                                                               options:NSRegularExpressionSearch
                                                                 range:NSMakeRange(0, [json length])];
    
    validString = [validString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])'"
                                                         withString:@"$1\""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, [validString length])];
    validString = [validString stringByReplacingOccurrencesOfString:@"'([:\\],\\}])"
                                                         withString:@"\"$1"
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, [validString length])];
    
    validString = [validString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])(\\w+)\\s*:"
                                                         withString:@"$1\"$2\":"
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, [validString length])];
    validString = [validString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    return validString;
}

- (NSString *)generateQueryStrWithParams:(NSDictionary *)params {
    NSString *queryStr = @"";
    NSArray *keys = params.allKeys;
    for (int i = 0; i < keys.count; i ++) {
        NSString *key = keys[i];
        if (i == 0) {
            queryStr = [NSString stringWithFormat:@"?%@=%@", key, params[key]];
        }
        else {
            NSString *str = [NSString stringWithFormat:@"&%@=%@", key, params[key]];
            queryStr = [queryStr stringByAppendingString:str];
        }
    }
    return queryStr;
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

@end
