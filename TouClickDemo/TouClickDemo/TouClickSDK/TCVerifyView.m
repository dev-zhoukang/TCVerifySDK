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

@end

@implementation TCVerifyView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _submitBtn.clipsToBounds = true;
    _submitBtn.layer.cornerRadius = 15.f;
    _submitBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _submitBtn.layer.borderWidth = 1.f;
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

@end