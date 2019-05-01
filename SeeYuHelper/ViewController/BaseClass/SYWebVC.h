//
//  SYWebVC.h
//  SeeYu
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有需要显示WKWebView的自定义视图控制器的基类

#import "SYVC.h"
#import "SYWebVM.h"
#import <WebKit/WebKit.h>
#import "SYWebVM.h"

@interface SYWebVC : SYVC<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;

/// 内容缩进 (64,0,0,0)
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong) SYWebVM *viewModel;

@end
