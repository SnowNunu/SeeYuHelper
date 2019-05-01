//
//
//  MBProgressHUD+SYExtension.m
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 CoderMikeHe. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SYExtension)

/// in window
/// 提示信息
+ (MBProgressHUD *)sy_showTips:(NSString *)tipStr;

/// 提示错误
+ (MBProgressHUD *)sy_showErrorTips:(NSError *)error;

/// 提示错误文本
+ (MBProgressHUD *)sy_showError:(NSString *)error;

/// 进度view
+ (MBProgressHUD *)sy_showProgressHUD:(NSString *)titleStr;

/// 隐藏hud
+ (void)sy_hideHUD;




/// in special view
/// 提示信息
+ (MBProgressHUD *)sy_showTips:(NSString *)tipStr addedToView:(UIView *)view;

/// 提示错误
+ (MBProgressHUD *)sy_showErrorTips:(NSError *)error addedToView:(UIView *)view;

/// 进度view
+ (MBProgressHUD *)sy_showProgressHUD:(NSString *)titleStr addedToView:(UIView *)view;

/// 隐藏hud
+ (void)sy_hideHUDForView:(UIView *)view;


@end
