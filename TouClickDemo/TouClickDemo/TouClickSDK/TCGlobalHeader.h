//
//  TCGlobalHeader.h
//  TouClickDemo
//
//  Created by ZK on 2017/4/3.
//  Copyright © 2017年 ZK. All rights reserved.
//

#ifndef TCGlobalHeader_h
#define TCGlobalHeader_h

#define GlobalBlueColor_Normal  [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:1]
#define GlobalBlueColor_HL      [UIColor colorWithRed:43/255.f green:138/255.f blue:194/255.f alpha:1]
#define GlobalBlueColor_Disabled  [UIColor colorWithRed:63/255.f green:158/255.f blue:214/255.f alpha:.4]

#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define WindowZoomScale      (SCREEN_WIDTH/320.f)

#define KeyboardAnimationCurve  7 << 16

#endif /* TCGlobalHeader_h */
