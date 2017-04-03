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
#import "ZKLoading.h"
#import "TCGlobalHeader.h"
#import "TCCheckModel.h"
#import "TCVerifyModel.h"

@interface TCVerifyView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgWidth;
@property (weak, nonatomic) IBOutlet UIView             *containerView;
@property (weak, nonatomic) IBOutlet UIButton           *submitBtn;
@property (weak, nonatomic) IBOutlet UIView             *bgView;
@property (weak, nonatomic) IBOutlet UIImageView        *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *thumbnailLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *thumbnailRightImageView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (nonatomic, strong) NSMutableArray <UIView *> *bubbles;
@property (nonatomic, assign) CGFloat                   scaling; // 缩放系数
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, strong) TCCheckModel *checkModel;
@property (nonatomic, copy) NSString *verifySid;
@property (nonatomic, copy) void (^completion)(TCVerifyModel *);

@end

@implementation TCVerifyView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    [self checkDataAndThen:^(){
        [self requestCaptcha];
    }];
}

- (void)checkDataAndThen:(void (^) ())callback {

    [self disableSubmitBtn:true];
    NSString *path = TCUrl_Check;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cb"] = [NSString stringWithFormat:@"beh%@", [self getSID]];
    params[@"b"] = TCPublicKey;
    params[@"ran"] = [NSString stringWithFormat:@"%f", TCRandom];
    [ZKLoading showCircleView:_topImageView];
    
    [[TCNetManager shareInstance] getRequest:path params:params callback:^(NSError *error, NSDictionary *res) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        _checkModel = [TCCheckModel modelWithDict:res];
        !callback?:callback();
    }];
}

- (void)disableSubmitBtn:(BOOL)disabled {
    _submitBtn.enabled = !disabled;
    _submitBtn.layer.borderColor = disabled ? GlobalBlueColor_Disabled.CGColor : GlobalBlueColor_Normal.CGColor;
}

- (void)requestCaptcha {
    NSString *path = TCUrl_Captcha;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cb"] = [NSString stringWithFormat:@"cb%@", [self getSID]];
    params[@"b"] = TCPublicKey;
    params[@"ct"] = @"14";
    params[@"sid"] = _checkModel.sid;
    params[@"ran"] = [NSString stringWithFormat:@"%f", TCRandom];
    [[TCNetManager shareInstance] getRequest:path params:params callback:^(NSError *error, NSDictionary *res) {
        
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        _verifySid = res[@"sid"];
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *key in res[@"data"]) {
            [images addObject:res[@"data"][key]];
        }
        _topImageView.image = [self generateImageWithBase64Str:[self restore:images[0]]];
        NSLog(@"oriImgSize ==> %@", NSStringFromCGSize(_topImageView.image.size));
        _scaling = (_topImageView.image.size.width / 2.f) / _topImageView.us_width;
        
        _thumbnailRightImageView.image = [self generateImageWithBase64Str:[self restore:images[1]]];
        if (images.count > 2) {
            _thumbnailLeftImageView.hidden = false;
            _thumbnailLeftImageView.image = [self generateImageWithBase64Str:[self restore:images[2]]];
        }
        else {
            _thumbnailLeftImageView.hidden = true;
        }
        [ZKLoading hide];
        _refreshBtn.enabled = true;
        [self disableSubmitBtn:false];
    }];
}

- (UIImage *)generateImageWithBase64Str:(NSString *)base64Str {
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: base64Str]];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

- (NSString *)restore:(NSDictionary *)b64Dict {
    
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

- (void)setup {
    _bubbles = [[NSMutableArray alloc] init];
    
    _submitBtn.clipsToBounds = true;
    _submitBtn.layer.cornerRadius = 15.f;
    _submitBtn.layer.borderWidth = 1.f;
    [_submitBtn setTitleColor:GlobalBlueColor_Normal forState:UIControlStateNormal];
    [_submitBtn setTitleColor:GlobalBlueColor_Disabled forState:UIControlStateDisabled];
    
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

+ (instancetype)showWithCompletion:(void (^)(TCVerifyModel *))completion {
    TCVerifyView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    view.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = [UIScreen mainScreen].bounds;
    
    view.topImgWidth.constant = 235.f * WindowZoomScale;
    
    view.containerView.layer.transform = CATransform3DMakeScale(.01f, .01f, 1.f);
    view.containerView.alpha = 0.0f;
    
    view.completion = completion;
    
    [UIView animateWithDuration:.02
                          delay:0.0 options:KeyboardAnimationCurve
                     animations:^{
                         view.bgView.alpha = 1;
                         view.containerView.layer.transform = CATransform3DIdentity;
                         view.containerView.alpha = 1.0f;
                         
                     } completion:nil];
    
    return view;
}

- (void)clearBubbles {
    [_bubbles enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_bubbles removeAllObjects];
}

- (IBAction)refreshAction:(UIButton *)btn {
    if (_bubbles.count) {
        [self clearBubbles];
    }
    
    btn.enabled = false;
    
    [self checkDataAndThen:^{
        [self requestCaptcha];
    }];
}

- (IBAction)closeAction:(id)sender {
    [UIView animateWithDuration:.02
                          delay:0.0 options:KeyboardAnimationCurve
                     animations:^{
                         self.containerView.layer.transform = CATransform3DMakeScale(.001, .001, 1.f);
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (IBAction)submitAction:(UIButton *)btn {
    btn.backgroundColor = [UIColor whiteColor];
    [self disableSubmitBtn:true];
    
    [btn setTitleColor:GlobalBlueColor_Normal forState:UIControlStateNormal];
    
    if (!_bubbles.count) {
        NSLog(@"没有点击选择图片，验证失败");
        [self verifyError];
        return;
    }
    
    __block NSString *locationStr = @"";
    [_bubbles enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pointStr = [NSString stringWithFormat:@"%d,%d,", (int)(view.center.x * _scaling), (int)(view.center.y * _scaling)];
        locationStr = [locationStr stringByAppendingString:pointStr];
    }];
    
    locationStr = [locationStr substringToIndex:locationStr.length - 1];
    
    NSLog(@"locationStr ==> %@", locationStr);

    NSString *path = TCUrl_Verify;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"r"] = locationStr;
    params[@"ran"] = [NSString stringWithFormat:@"%f", TCRandom];
    params[@"cb"] = [NSString stringWithFormat:@"ve%@", [self getSID]];
    params[@"sid"] = _verifySid;
    params[@"b"] = TCPublicKey;
    params[@"ckcode"] = @"";
    params[@"ct"] = @"14";
    
    [[TCNetManager shareInstance] getRequest:path params:params callback:^(NSError *error, NSDictionary *res) {
       NSLog(@"verify res ===> %@", res);
        TCVerifyModel *model = [TCVerifyModel modelWithDict:res];
        [self clearBubbles];
        if (!model.token) {
            [self verifyError];
        }
        else {
            _topImageView.image = [UIImage imageNamed:@"OK"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction:nil];
                !_completion?:_completion(model);
            });
        }
    }];
}

- (void)verifyError {
    _topImageView.image = [UIImage imageNamed:@"error"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshAction:nil];
    });
}

- (NSString *)getSID {
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

- (NSString *)getChar:(int)code {
    if (code < 10) {
        return [NSString stringWithFormat:@"%d", code];
    }
    int newCode = code + 55;
    NSString *codeStr = [NSString stringWithUTF8String:(char *)&(newCode)];
    return codeStr;
}

- (IBAction)submitBtnTouchDown:(UIButton *)btn {
    btn.backgroundColor = GlobalBlueColor_Normal;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)dealloc {
    NSLog(@"VerityView delloc");
}

@end
