//
//  TCViewController.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCViewController.h"
#import "TCVerifyButton.h"
#import "UIView+Addition.h"

#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)

@interface TCViewController ()

@end

@implementation TCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    TCVerifyButton *verifyBtn = [[TCVerifyButton alloc] init];
    [verifyBtn verifyBtnWithCompletion:^(NSDictionary * _Nullable cbData) {
        
    }];
    verifyBtn.us_size = (CGSize){SCREEN_WIDTH - 80, 45.f};
    verifyBtn.us_top = 400.f;
    verifyBtn.us_left = 40.f;
    [self.view addSubview:verifyBtn];
    
}

@end
