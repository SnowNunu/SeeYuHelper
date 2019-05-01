//
//
//  MBProgressHUD+SYExtension.m
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 CoderMikeHe. All rights reserved.
//

#import "MBProgressHUD+SYExtension.h"
#import "NSError+SYExtension.h"
@implementation MBProgressHUD (SYExtension)

#pragma mark - Added To  window
/// 提示信息
+ (MBProgressHUD *)sy_showTips:(NSString *)tipStr{
    return [self sy_showTips:tipStr addedToView:nil];
}

/// 提示错误
+ (MBProgressHUD *)sy_showErrorTips:(NSError *)error{
    return [self sy_showErrorTips:error addedToView:nil];
}

/// 提示错误文本
+ (MBProgressHUD *)sy_showError:(NSString *)error{
    return [self sy_showError:error addedToView:nil];
}

/// 进度view
+ (MBProgressHUD *)sy_showProgressHUD:(NSString *)titleStr
{
    return [self sy_showProgressHUD:titleStr addedToView:nil];
}

/// hide hud
+ (void)sy_hideHUD
{
    [self sy_hideHUDForView:nil];
}


#pragma mark - Added To Special View
/// 提示信息
+ (MBProgressHUD *)sy_showTips:(NSString *)tipStr addedToView:(UIView *)view
{
    return [self _showHUDWithTips:tipStr isAutomaticHide:YES addedToView:view];
}

/// 提示错误
+ (MBProgressHUD *)sy_showErrorTips:(NSError *)error addedToView:(UIView *)view
{
    return [self _showHUDWithTips:[self sy_tipsFromError:error] isAutomaticHide:YES addedToView:view];
}

/// 提示错误文本
+ (MBProgressHUD *)sy_showError:(NSString *)error addedToView:(UIView *)view
{
    return [self _showHUDWithTips:error isAutomaticHide:YES addedToView:view];
}


/// 进度view
+ (MBProgressHUD *)sy_showProgressHUD:(NSString *)titleStr addedToView:(UIView *)view{
    return [self _showHUDWithTips:titleStr isAutomaticHide:NO addedToView:view];
}

// 隐藏HUD
+ (void)sy_hideHUDForView:(UIView *)view
{
    [self hideHUDForView:[self _willShowingToViewWithSourceView:view] animated:YES];
}

#pragma mark - 辅助方法
/// 获取将要显示的view
+ (UIView *)_willShowingToViewWithSourceView:(UIView *)sourceView
{
    if (sourceView) return sourceView;
    
    sourceView =  [[UIApplication sharedApplication].delegate window];
    if (!sourceView) sourceView = [[[UIApplication sharedApplication] windows] lastObject];
    
    return sourceView;
}

+ (instancetype )_showHUDWithTips:(NSString *)tipStr isAutomaticHide:(BOOL) isAutomaticHide addedToView:(UIView *)view
{
    view = [self _willShowingToViewWithSourceView:view];
    
    /// 也可以show之前 hid掉之前的
    [self sy_hideHUDForView:view];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = isAutomaticHide?MBProgressHUDModeText:MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.font = isAutomaticHide?SYMediumFont(17.0f):SYMediumFont(14.0f);
    hud.label.textColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = tipStr;
    hud.bezelView.layer.cornerRadius = 8.0f;
    hud.bezelView.layer.masksToBounds = YES;
    hud.bezelView.color = SYColorAlpha(0, 0, 0, .6f);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.layer.cornerRadius = 8.0f;
    hud.bezelView.layer.masksToBounds = YES;
    hud.bezelView.color = SYColorAlpha(0, 0, 0, .6f);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.minSize =isAutomaticHide?CGSizeMake([UIScreen mainScreen].bounds.size.width-96.0f, 60):CGSizeMake(120, 120);
    hud.margin = 18.2f;
    hud.removeFromSuperViewOnHide = YES;
    if (isAutomaticHide) [hud hideAnimated:YES afterDelay:1.0f];
    return hud;
}


#pragma mark - 辅助属性
+ (NSString *)sy_tipsFromError:(NSError *)error{
    return [NSError sy_tipsFromError:error];
}
@end
