//
//  YLShortVideoVC.h
//  NHZGame
//
//  Created by MH on 2017/6/27.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
#define Screen_WIDTH [UIScreen mainScreen].bounds.size.width
#define Screen_HEIGTH [UIScreen mainScreen].bounds.size.height
#define Width(i) i*(Screen_WIDTH/375)
#define FONT(x)        [UIFont systemFontOfSize:Width(x)]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface YLShortVideoVC : UIViewController

@property(nonatomic,copy)void(^shortVideoBack)(NSURL *videoUrl);

@end
