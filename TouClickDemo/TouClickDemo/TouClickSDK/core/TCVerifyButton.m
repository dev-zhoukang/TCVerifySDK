//
//  TCVerifyButton.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCVerifyButton.h"
#import "UIView+Addition.h"
#import "TCVerifyView.h"
#import "TCGlobalHeader.h"
#import "TCVerifyModel.h"
#import "TCVerifyTabbar.h"

@interface TCVerifyButton()

typedef void (^ZKSettingItemBlock)(NSString *token);

@property (nonatomic, copy) ZKSettingItemBlock completion;
@property (nonatomic, assign) BOOL passed;

@end

@implementation TCVerifyButton

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)verifyCompletion:(void (^)(NSString * _Nullable))completion {
    _completion = completion;
}

- (void)setup {
    
    _passed = false;
    
    self.backgroundColor = GlobalBlueColor_Normal;
    [self setImage:[UIImage imageNamed:@"logo-w"] forState:UIControlStateNormal];
    [self setTitle:@"点击进行认证" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 4.f;
    self.adjustsImageWhenHighlighted = false;
    
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUp {
    self.backgroundColor = GlobalBlueColor_Normal;
}

- (void)touchDown {
    self.backgroundColor = GlobalBlueColor_HL;
}

- (void)clickAction {
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    DLog(@"start verify");
    [self setSucceeStyle:false];
    
    NSString *ct = [TCVerifyTabbar getSelectdType];
    [TCVerifyView showWithCt:ct Completion:^(TCVerifyModel *verifyModel) {
        
        if (verifyModel) {
            !_completion?:_completion(verifyModel.token);
            
            [self setSucceeStyle:true];
        }
        else {
            !_completion?:_completion(nil);
        }
    }];
}

- (void)setSucceeStyle:(BOOL)success {
    
    void(^animations)() = nil;
    
    if (success) {
        animations = ^() {
            self.backgroundColor = [UIColor colorWithRed:80/255.f green:174/255.f blue:85/255.f alpha:1];
            [self setTitle:@"验证成功" forState:UIControlStateNormal];
            _passed = true;
        };
    }
    else {
        animations = ^() {
            self.backgroundColor = GlobalBlueColor_Normal;
            [self setTitle:@"点击进行认证" forState:UIControlStateNormal];
            _passed = false;
        };
    }
    [UIView animateWithDuration:.8f animations:animations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    if (CGRectEqualToRect(CGRectZero, imageViewFrame) || CGRectEqualToRect(CGRectZero, titleFrame)) {
        return;
    }
    
    imageViewFrame.origin.x = 10.f;
    imageViewFrame.origin.y = truncf((self.bounds.size.height - imageViewFrame.size.height) * 0.5);
    self.imageView.frame = imageViewFrame;
    
    titleFrame.origin.x = truncf((self.bounds.size.width - titleFrame.size.width) * 0.5);
    titleFrame.origin.y = truncf((self.bounds.size.height - titleFrame.size.height) * 0.5);
    self.titleLabel.frame = titleFrame;
}

@end
