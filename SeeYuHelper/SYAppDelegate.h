//
//  AppDelegate.h
//  SeeYu
//
//  Created by trc on 2019/01/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNavigationControllerStack.h"
#import "SYViewModelServicesImpl.h"
#import "RCCallBaseViewController.h"

@interface SYAppDelegate : UIResponder <UIApplicationDelegate>

/// 窗口
@property (strong, nonatomic) UIWindow *window;


/// 获取AppDelegate
+ (SYAppDelegate *)sharedDelegate;

/// APP管理的导航栏的堆栈
@property (nonatomic, readwrite, strong) SYNavigationControllerStack *navigationControllerStack;

/// APP的服务层
@property (nonatomic, readwrite, strong) SYViewModelServicesImpl *services;

/// 是否已经弹出键盘 主要用于微信朋友圈的判断
@property (nonatomic, readwrite, assign , getter = isShowKeyboard) BOOL showKeyboard;

@property(nonatomic, strong) NSMutableArray *callWindows;

- (void)presentVC:(UIViewController *)vc withAnimation:(CATransition *)animation;

- (void)dismissVC:(UIViewController *)vc;

@end

