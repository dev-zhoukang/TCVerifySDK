//
//  TCVerifyView.m
//  TouClickDemo
//
//  Created by ZK on 2017/3/30.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "TCVerifyView.h"
#import "UIView+Addition.h"

@interface TCVerifyView()

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailRightImageView;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableArray *bubbles;

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
    NSURL *url = [NSURL URLWithString:@"http://cap-5-2-0.touclick.com/public/captcha?cb=cb15B27852452D9PZS4X0N9U67IIGFC2H6&b=45f5b905-4d15-41ca-ba4b-3a8612fc43cf&ct=14&sid=4764d7ca-782b-434a-b0cb-5b775e16ad01&ran=0.07404862641221288"];
    _session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!jsonStr.length) {
            NSLog(@"jsonStr 为空");
            return;
        }
        
        NSString *subStr = [jsonStr componentsSeparatedByString:@"("][1];
        subStr = [subStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSData *jsonData = [subStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *item in dict[@"data"]) {
            [images addObject:dict[@"data"][item]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _topImageView.image = [self generateImageWithBase64Str:[self restore:images[0]]];
            _thumbnailLeftImageView.image = [self generateImageWithBase64Str:[self restore:images[1]]];
            if (images[2]) {
                _thumbnailRightImageView.hidden = false;
                _thumbnailRightImageView.image = [self generateImageWithBase64Str:[self restore:images[2]]];
            }
            else {
                _thumbnailRightImageView.hidden = true;
            }
        });
    }];
    [task resume];
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
    _submitBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _submitBtn.layer.borderWidth = 1.f;
    
    _topImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopImageViewTap:)];
    [_topImageView addGestureRecognizer:tap];
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
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.us_height = 270.f;
    view.us_width = 255.f;
    view.center = view.superview.center;
    
    view.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    view.alpha = 0.0f;
    
    [UIView animateWithDuration:.25
                          delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1.0f;
                         
                     } completion:^(BOOL finished) {
                     }];
    
    return view;
}

- (IBAction)refreshAction {
    
}

- (IBAction)closeAction:(id)sender {
    
}

- (IBAction)submitAction:(id)sender {
    
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

@end
