//
//  SYControllerHelper.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYControllerHelper.h"
#import "SYHomePageVC.h"

@implementation SYControllerHelper

+ (UIViewController *)currentViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    /// CoderMikeHe Fixed : 这里必须要判断一下，否则取出来永远都是 SYHomePageVC。这是架构上小缺(特)陷(性)。因为SYHomePageVC的子控制器是UITabBarController，所以需要递归UITabBarController的所有的子控制器
    if ([resultVC isKindOfClass:[SYHomePageVC class]]) {
        SYHomePageVC *mainVc = (SYHomePageVC *)resultVC;
        resultVC = [self _topViewController:mainVc.tabBarController];
    }
    
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}


+ (UINavigationController *)topNavigationController{
    return SYSharedAppDelegate.navigationControllerStack.topNavigationController;
}

+ (SYVC *)topViewController
{
    SYVC *topViewController = (SYVC *)[self topNavigationController].topViewController;
    
    /// 确保解析出来的类 也是 SYVC
    NSAssert([topViewController isKindOfClass:SYVC.class], @"topViewController is not an SYVC subclass: %@", topViewController);
    
    return topViewController;
}

@end
