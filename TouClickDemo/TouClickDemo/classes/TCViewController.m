//
//  TCViewController.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCViewController.h"
#import "TCVerifySDK.h"

#define INPUTVIEW_WIDTH  (230.f * WindowZoomScale)
#define GRAY_COLOR       [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1]

@interface TCViewController ()

@property (nonatomic, strong) UIView         *contentView;
@property (nonatomic, strong) UIView         *accountView;
@property (nonatomic, strong) UIView         *pwdView;
@property (nonatomic, strong) UIButton       *loginBtn;
@property (nonatomic, strong) TCVerifyButton *verifyBtn;

@end

static const CGFloat kDefaultMargin = 15.f;

@implementation TCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    
    [self setupScrollView];
    [self setupLogoView];
    
    _accountView = [self setupInputView:@"账户"];
    _accountView.us_centerY = _contentView.us_centerY - 100.f;
    
    _pwdView = [self setupInputView:@"密码"];
    _pwdView.us_top = CGRectGetMaxY(_accountView.frame) + kDefaultMargin;
    
    [self setupVerifyView];
    
    [self setupLoginBtn];
}

/**
 开发者只需关心该方法内的实现，verifyBtn 是验证按钮，其 UI 和 点击验证事件已封装在内部，验证结果会通过 verifyCompletion block 回调给开发者。所以开发者只需设置其 frame 布局和接收回调即可。
 底部的选择验证方式的 tabbar 只需实现 `showTabbarOnView:` 即可。layout 布局和点击按钮更换验证方式的逻辑已封装在内部。如果开发者有监听点击更换验证方式的需求，只需将上面的 show 方法改成带有回调的即可，即`showTabbarOnView: selectTypeCallback:`。
 */
- (void)setupVerifyView {
    _verifyBtn = [[TCVerifyButton alloc] init];
    [_contentView addSubview:_verifyBtn];
    [_verifyBtn verifyCompletion:^(NSString * _Nullable token) {
        if (token) {
            DLog(@"验证成功, 获取到 tocken ==> %@", token);
        }
        else {
            DLog(@"验证失败");
        }
    }];
    _verifyBtn.us_size = (CGSize){INPUTVIEW_WIDTH, 45.f};
    _verifyBtn.us_centerX = _verifyBtn.superview.us_centerX;
    _verifyBtn.us_top = CGRectGetMaxY(_pwdView.frame) + kDefaultMargin;
    
    [TCVerifyTabbar showTabbarOnView:self.view];
}

- (void)setupLoginBtn {
    UIButton *loginBtn = [[UIButton alloc] init];
    [_contentView addSubview:loginBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = GRAY_COLOR;
    loginBtn.us_size = (CGSize){INPUTVIEW_WIDTH, 50.f};
    loginBtn.us_centerX = loginBtn.superview.us_centerX;
    loginBtn.us_top = CGRectGetMaxY(_verifyBtn.frame) + kDefaultMargin;
    loginBtn.layer.cornerRadius = 5.f;
    [loginBtn setShowsTouchWhenHighlighted:true];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLogoView {
    UIView *logoView = [UIView new];
    [_contentView addSubview:logoView];
    logoView.frame = (CGRect){CGPointZero, SCREEN_WIDTH, 120.f * WindowZoomScale};
    UIImageView *imageView = [[UIImageView alloc] init];
    [logoView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"logo-touclick"];
    imageView.us_size = (CGSize){120.f, 60.f};
    imageView.us_top = 50.f * WindowZoomScale;
    imageView.us_centerX = imageView.superview.us_centerX;
    
    UIView *line = [UIView new];
    [logoView addSubview:line];
    line.us_size = (CGSize){150 * WindowZoomScale, 1.2f};
    line.us_top = CGRectGetMaxY(imageView.frame) + 15.f;
    line.us_centerX = line.superview.us_centerX;
    line.backgroundColor = [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:1];
}

- (void)setupScrollView {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.contentSize = (CGSize){SCREEN_WIDTH, SCREEN_HEIGHT};
    [self.view addSubview:scrollView];
    scrollView.alwaysBounceVertical = true;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _contentView = [UIView new];
    _contentView.frame = (CGRect){CGPointZero, scrollView.contentSize};
    [scrollView addSubview:_contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapContentView)];
    [_contentView addGestureRecognizer:tap];
}

- (UIView *)setupInputView:(NSString *)title {
    UIView *view = [UIView new];
    [_contentView addSubview:view];
    view.us_size = (CGSize){INPUTVIEW_WIDTH, 50.f};
    view.us_centerX = view.superview.us_centerX;
    
    view.layer.borderColor = GRAY_COLOR.CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.cornerRadius = 5.f;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [title stringByAppendingString:@":"];
    [view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = GRAY_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = (CGRect){CGPointZero, 60.f, CGRectGetHeight(view.frame)};
    
    UITextField *field = [UITextField new];
    [view addSubview:field];
    field.keyboardType = UIKeyboardTypeEmailAddress;
    field.secureTextEntry = [title isEqualToString:@"密码"];
    field.us_origin = (CGPoint){CGRectGetMaxX(titleLabel.frame), 0};
    field.us_size = (CGSize){CGRectGetWidth(view.frame) - CGRectGetMaxX(titleLabel.frame) - 10.f, 30};
    field.us_centerY = view.us_centerY + 1.f;
    field.font = [UIFont systemFontOfSize:15.f];
    field.clipsToBounds = true;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.placeholder = @"测试请随意填写";
    
    return view;
}

- (void)handleTapContentView {
    [self.view endEditing:true];
}

- (void)loginAction {
    DLog(@"login");
}

@end
