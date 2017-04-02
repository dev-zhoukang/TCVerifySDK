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

#define BtnTintColor_Normal  [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:1]
#define BtnTintColor_HL      [UIColor colorWithRed:43/255.f green:138/255.f blue:194/255.f alpha:1]

@interface TCVerifyButton()

typedef void (^ZKSettingItemBlock)(NSDictionary *cbData);

@property (nonatomic, copy) ZKSettingItemBlock completion;

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

- (void)verifyBtnWithCompletion:(void (^)(NSDictionary * _Nullable))completion {
    _completion = completion;
}

- (void)setup {
    self.backgroundColor = BtnTintColor_Normal;
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
    self.backgroundColor = BtnTintColor_Normal;
}

- (void)touchDown {
    self.backgroundColor = BtnTintColor_HL;
}

- (void)clickAction {
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    NSLog(@"start verify");
    [TCVerifyView show];
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
