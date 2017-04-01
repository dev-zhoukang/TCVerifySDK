//
//  TCVerifyView.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCVerifyView.h"
#import "UIView+Addition.h"
#import "TCNetManager.h"

#define SCREEN_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define WindowZoomScale      (SCREEN_WIDTH/320.f)
#define KeyboardAnimationCurve  7 << 16

@interface TCVerifyView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgWidth;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailRightImageView;
@property (nonatomic, strong) NSMutableArray <UIView *> *bubbles;
@property (nonatomic, assign) CGFloat scaling; // 缩放系数

@end

// url:"http://cap-5-2-0.touclick.com/public/captcha?b="+PUB+"&ct=13,&sid="+$.cookie("touclick-sid")+"&ran=" + Math.random(),
static NSString *const pubKey = @"9c233422-a783-4522-b279-2393e9d9a8e2";
static NSString *const requestCaptchaUrl = @"http://cap-5-2-0.touclick.com/public/captcha?";

@implementation TCVerifyView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    [self requestData];
}

- (void)requestData {
    
    NSString *path = @"http://cap-5-2-0.touclick.com/public/captcha?cb=cb15B27852452D9PZS4X0N9U67IIGFC2H6&b=45f5b905-4d15-41ca-ba4b-3a8612fc43cf&ct=14&sid=4764d7ca-782b-434a-b0cb-5b775e16ad01&ran=0.07404862641221288";
    
    [[TCNetManager shareInstance] getRequest:path params:nil callback:^(BOOL success, NSDictionary *res) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *item in res[@"data"]) {
            [images addObject:res[@"data"][item]];
        }
        _topImageView.image = [self generateImageWithBase64Str:[self restore:images[0]]];
        NSLog(@"topImgSize ==> %@", NSStringFromCGSize(_topImageView.image.size));
        _scaling = (_topImageView.image.size.width / [UIScreen mainScreen].scale) / _topImageView.us_width;
        
        _thumbnailRightImageView.image = [self generateImageWithBase64Str:[self restore:images[1]]];
        if (images.count > 2) {
            _thumbnailLeftImageView.hidden = false;
            _thumbnailLeftImageView.image = [self generateImageWithBase64Str:[self restore:images[2]]];
        }
        else {
            _thumbnailLeftImageView.hidden = true;
        }
    }];
}

- (UIImage *)generateImageWithBase64Str:(NSString *)base64Str {
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: base64Str]];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

- (NSString *)restore:(NSDictionary *)b64Dict {
    
    NSString *base64Str = [b64Dict[@"baseStr"] copy];
    
    NSInteger ran_count = (float)(1+arc4random()%99)/100 * 500;
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

- (void)setup {
    _bubbles = [[NSMutableArray alloc] init];
    
    _submitBtn.clipsToBounds = true;
    _submitBtn.layer.cornerRadius = 15.f;
    _submitBtn.layer.borderColor = [UIColor colorWithRed:31/255.f green:140/255.f blue:194/255.f alpha:1.f].CGColor;
    _submitBtn.layer.borderWidth = 1.f;
    
    _topImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopImageViewTap:)];
    [_topImageView addGestureRecognizer:tap];
    
    _containerView.layer.cornerRadius = 6.f;
}

- (void)handleTopImageViewTap:(UIGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:tap.view];
    NSLog(@"add location ==> %@", NSStringFromCGPoint(location));
    
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble2"]];
    CGSize bubbleSize = bubbleView.us_size;
    bubbleView.us_origin = (CGPoint){location.x - bubbleSize.width * .5, location.y - bubbleSize.height * .5};
    [_topImageView addSubview:bubbleView];
    bubbleView.userInteractionEnabled = true;
    UITapGestureRecognizer *bubbletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBubbleTap:)];
    [bubbleView addGestureRecognizer:bubbletap];
    [_bubbles addObject:bubbleView];
}

- (void)handleBubbleTap:(UIGestureRecognizer *)tap {
    NSLog(@"delete location ==> %@", NSStringFromCGPoint(tap.view.center));
    [tap.view removeFromSuperview];
    [_bubbles removeObject:tap.view];
}

+ (instancetype)show {
    TCVerifyView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    view.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = [UIScreen mainScreen].bounds;
    
    view.topImgWidth.constant = 235.f * WindowZoomScale;
    view.containerView.layer.transform = CATransform3DMakeScale(.01f, .01f, 1.f);
    view.containerView.alpha = 0.0f;
    
    [UIView animateWithDuration:.25
                          delay:0.0 options:KeyboardAnimationCurve
                     animations:^{
                         view.bgView.alpha = 1;
                         view.containerView.layer.transform = CATransform3DIdentity;
                         view.containerView.alpha = 1.0f;
                         
                     } completion:^(BOOL finished) {
                     }];
    
    return view;
}

- (IBAction)refreshAction {
    if (_bubbles.count) {
        [_bubbles removeAllObjects];
    }
    [self requestData];
}

- (IBAction)closeAction:(id)sender {
    [UIView animateWithDuration:.25
                          delay:0.0 options:KeyboardAnimationCurve
                     animations:^{
                         self.containerView.layer.transform = CATransform3DMakeScale(.001, .001, 1.f);
                         self.bgView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (IBAction)submitAction:(id)sender {
    
    if (!_bubbles.count) {
        NSLog(@"没有点击选择图片，验证失败");
        return;
    }
    
    __block NSString *locationStr = @"";
    [_bubbles enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pointStr = [NSString stringWithFormat:@"%d,%d,", (int)(view.center.x * _scaling), (int)(view.center.y * _scaling)];
        locationStr = [locationStr stringByAppendingString:pointStr];
    }];
    
    locationStr = [locationStr substringToIndex:locationStr.length - 1];
    
    NSLog(@"locationStr ==> %@", locationStr);
    
    NSString *path = @"http://ver-5-2-0.touclick.com/verifybehavior?b=45f5b905-4d15-41ca-ba4b-3a8612fc43cf&cb=ve15B2786223F0EW23SSZ4VOK5C2J32P1I&ct=14&ckcode=&sid=758db795-2604-4fda-9825-5557d04d10ee&r=676,200,829,225&ran=0.6501818895574928";
    [[TCNetManager shareInstance] getRequest:path params:nil callback:^(BOOL success, NSDictionary *res) {
       NSLog(@"res ===> %@", res);
    }];
}

@end
