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
#import "TCGlobalHeader.h"
#import "TCVerifyTabbar.h"

#define INPUTVIEW_WIDTH  (230.f * WindowZoomScale)
#define GRAY_COLOR       [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1]

@interface TCViewController ()

@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton    *loginBtn;

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
    [TCVerifyTabbar showTabbarOnView:self.view];
    
    UIView *accountView = [self setupInputView:@"账户"];
    accountView.us_centerY = _contentView.us_centerY - 100.f;
    
    UIView *pwdView = [self setupInputView:@"密码"];
    pwdView.us_top = CGRectGetMaxY(accountView.frame) + kDefaultMargin;
    
    TCVerifyButton *verifyBtn = [[TCVerifyButton alloc] init];
    [_contentView addSubview:verifyBtn];
    [verifyBtn verifyCompletion:^(NSString * _Nullable token) {
        if (token) {
            DLog(@"验证成功, 获取到 tocken ==> %@", token);
        }
        else {
            DLog(@"验证失败");
        }
    }];
    
    verifyBtn.us_size = (CGSize){INPUTVIEW_WIDTH, 45.f};
    verifyBtn.us_centerX = verifyBtn.superview.us_centerX;
    verifyBtn.us_top = CGRectGetMaxY(pwdView.frame) + kDefaultMargin;
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [_contentView addSubview:loginBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = GRAY_COLOR;
    loginBtn.us_size = (CGSize){INPUTVIEW_WIDTH, 50.f};
    loginBtn.us_centerX = loginBtn.superview.us_centerX;
    loginBtn.us_top = CGRectGetMaxY(verifyBtn.frame) + kDefaultMargin;
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
