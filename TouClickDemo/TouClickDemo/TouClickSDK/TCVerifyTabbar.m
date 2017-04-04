//
//  TCVerifyTabbar.m
//  TouClickDemo
//
//  Created by ZK on 2017/4/4.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCVerifyTabbar.h"
#import "TCGlobalHeader.h"

@interface TCVerify : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ct;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end

@implementation TCVerify

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    TCVerify *model = [[TCVerify alloc] init];
    model.title = dict[@"title"];
    model.ct = dict[@"ct"];
    return model;
}

@end

@interface TCVerifyTabbar()

@property (nonatomic, copy) NSArray <TCVerify *> *dataSource;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation TCVerifyTabbar

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

+ (instancetype)showTabbarOnView:(UIView *)view {
    TCVerifyTabbar *tabbar = [TCVerifyTabbar new];
    [view addSubview:tabbar];
    return tabbar;
}

- (void)setup {
    
    self.us_size = (CGSize){SCREEN_WIDTH, 44.f};
    self.backgroundColor = [UIColor redColor];
    
    [self initData];
    [self initViews];
}

- (void)initData {
    NSArray *oriArray = @[
                           @{ @"title": @"图文验证", @"ct": @"13" },
                           @{ @"title": @"图标验证", @"ct": @"14" }
                           ];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:oriArray.count];
    for (NSDictionary *dict in oriArray) {
        TCVerify *model = [TCVerify modelWithDict:dict];
        [temp addObject:model];
    }
    _dataSource = temp.copy;
}

- (void)initViews {
    
    UIView *topLine = [[UIView alloc] init];
    [self addSubview:topLine];
    topLine.backgroundColor = [UIColor blackColor];
    topLine.us_size = (CGSize){SCREEN_WIDTH, 1.f};
    topLine.us_top = 1.f;
    topLine.layer.shadowOffset = (CGSize){-2.f, -2.f};
    topLine.layer.shadowOpacity = 1;
    topLine.layer.shadowRadius = 4.f;
    
    [_dataSource enumerateObjectsUsingBlock:^(TCVerify * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setupBarItem:model index:idx];
    }];
}

- (UIView *)setupBarItem:(TCVerify *)model index:(NSUInteger)idx {
    CGFloat btnWidth = SCREEN_WIDTH / _dataSource.count;
    CGFloat btnHeight = 44.f;
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.us_size = (CGSize){btnWidth, btnHeight};
    view.us_left = idx * btnWidth;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    btn.frame = view.bounds;
    btn.tag = idx;
    [btn setTitle:model.title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self resumeBtn:btn];
    [btn addTarget:self action:@selector(didSelectType:) forControlEvents:UIControlEventTouchUpInside];
    if (!idx) {
        [self didSelectType:btn];
    }
    
    return view;
}

- (void)didSelectType:(UIButton *)btn {
    TCVerify *model = _dataSource[btn.tag];
    
    [self highlightBtn:btn];
    [self resumeBtn:_selectedBtn];
    
    _selectedBtn = btn;
    
    NSLog(@"%@", model.ct);
}

- (void)highlightBtn:(UIButton *)btn {
    btn.backgroundColor = HexColor(0x3f9ed6);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)resumeBtn:(UIButton *)btn {
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:HexColor(0x535353) forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.us_bottom = SCREEN_HEIGHT;
}

@end
