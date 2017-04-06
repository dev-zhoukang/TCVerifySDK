# TCVerifySDK
智能验证码系统
### 集成步骤：
1.  `#import "TCVerifySDK.h"`
2. 实现下面方法，使用注意见注释

```objective-c
/**
  开发者只需关心该方法内的实现，verifyBtn 是验证按钮，其 UI 和 点击验证事件已封装在内部，
验证结果会通过 verifyCompletion block 回调给开发者。所以开发者只需设置其 frame 布局和接收回调即可。
  底部的选择验证方式的 tabbar 只需实现 `showTabbarOnView:` 即可。layout 布局和点击按钮更换验证方式的逻辑已封装在内部。
如果开发者有监听点击更换验证方式的需求，只需将上面的 show 方法改成带有回调的即可，即`showTabbarOnView: selectTypeCallback:`。
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
```
3. 通过上面两步即可完成对 TCVerifySDK 的智能验证码系统的集成。
更多功能参见 `TCVerifyButton` 和 `TCVerifyTabbar` 头文件
