//
//  TCVerifyUtil.m
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCVerifyUtil.h"
#import "TCGlobalHeader.h"

@implementation TCVerifyUtil

+ (UIImage *)generateImageWithBase64Dict:(NSDictionary *)dict {
    NSString *base64Str = [self restore:dict];
    UIImage *image = [self generateImageWithBase64Str:base64Str];
    return image;
}

+ (UIImage *)generateImageWithBase64Str:(NSString *)base64Str {
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: base64Str]];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

+ (NSString *)restore:(NSDictionary *)b64Dict {
    
    NSString *base64Str = [b64Dict[@"baseStr"] copy];
    
    NSInteger ran_count =  TCRandom * 500;
    NSInteger count_a = ([b64Dict[@"countA"] integerValue] - ran_count) % 4 + ran_count;
    
    for (int i = 0; i < count_a; i ++) {
        base64Str = [base64Str stringByAppendingString:@"A"];
    }
    for (int i = 0; i < [b64Dict[@"countEqual"] integerValue]; i++) {
        base64Str = [base64Str stringByAppendingString:@"="];
    }
    NSString *prefix = @"data:image/";
    NSString *suffix = @";base64,";
    NSDictionary *typeDict = @{ @"p": @"png", @"j": @"jpg" };
    
    NSString *typeStr = typeDict[b64Dict[@"f"]]?:typeDict[@"j"];
    
    base64Str = [[[prefix stringByAppendingString:typeStr] stringByAppendingString:suffix] stringByAppendingString:base64Str];
    return base64Str;
}

+ (NSString *)getSID {
    NSDate *date = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000.f];
    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1lx",(long)[timestamp integerValue]]];
    timestamp = [hexString uppercaseString];
    NSInteger count = 32 - [timestamp length];
    while (count --) {
        int code = TCRandom * 36;
        timestamp = [timestamp stringByAppendingString:[self getChar:code]];
    }
    return timestamp;
}

+ (NSString *)getChar:(int)code {
    if (code < 10) {
        return [NSString stringWithFormat:@"%d", code];
    }
    int newCode = code + 55;
    NSString *codeStr = [NSString stringWithUTF8String:(char *)&(newCode)];
    return codeStr;
}

@end
