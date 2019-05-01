//
//  SYMomentCommentToolView.h
//  WeChat
//
//  Created by senba on 2018/1/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  评论输入框

#import <UIKit/UIKit.h>
#import "SYReactiveView.h"

@interface SYMomentCommentToolView : UIView<SYReactiveView>

/// toHeight (随着文字的输入，SYMomentCommentToolView 将要到达的高度)
@property (nonatomic, readonly, assign) CGFloat toHeight;

/// 发布按钮
@property (nonatomic, readwrite, weak) UIButton *releaseBtn;

/// textView
@property (nonatomic, readwrite, weak) YYTextView *textView;

- (BOOL)sy_canBecomeFirstResponder;    // default is NO
- (BOOL)sy_becomeFirstResponder;
- (BOOL)sy_canResignFirstResponder;    // default is YES
- (BOOL)sy_resignFirstResponder;

@end
