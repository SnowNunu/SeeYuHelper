//
//  SYConstant.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYConstant.h"
#import <UIKit/UIKit.h>

#pragma mark - 应用相关的
/// 切换根控制器的通知 新特性
NSString * const SYSwitchRootViewControllerNotification = @"SYSwitchRootViewControllerNotification";
/// 切换根控制器的通知 UserInfo key
NSString * const SYSwitchRootViewControllerUserInfoKey = @"SYSwitchRootViewControllerUserInfoKey";

/// 全局分割线高度 .5
CGFloat const SYGlobalBottomLineHeight = 0.5f;

/// 个性签名的最大字数为20
NSUInteger const SYFeatureSignatureMaxWords = 20;

/// 用户昵称的最大字数为12
NSUInteger const SYNicknameMaxWords = 12;

/// 简书首页地址
NSString * const SYMyBlogHomepageUrl = @"http://www.jianshu.com/u/126498da7523";

/// 国家区号
NSString * const SYMobileLoginZoneCodeKey = @"SYMobileLoginZoneCodeKey";
/// 手机号码
NSString * const SYMobileLoginPhoneKey = @"SYMobileLoginPhoneKey";

/// 验证码时间
NSUInteger const SYCaptchaFetchMaxWords = 60;


/// 朋友圈 ---
/// 分割线高度
CGFloat const WXGlobalBottomLineHeight = .5f;


/// 以下是 微信朋友圈常量定义区

/// profileView
/// 头像宽高 15
CGFloat const SYMomentProfileViewAvatarViewWH = 75.0f;
/// 消息tips宽高 40
CGFloat const SYMomentProfileViewTipsViewHeight = 40.0f;
/// 消息tips宽高 181
CGFloat const SYMomentProfileViewTipsViewWidth = 181.0f;
/// 消息tipsView内部的头像宽高 30
CGFloat const SYMomentProfileViewTipsViewAvatarWH = 30.0f;
/// 消息tipsView内部的头像距离tipsView边距 5
CGFloat const SYMomentProfileViewTipsViewInnerInset = 5.0f;
/// 消息tipsView内部的右箭头距离tipsView边距 11
CGFloat const SYMomentProfileViewTipsViewRightInset = 11.0f;
/// 消息tipsView内部的右箭头宽高 15
CGFloat const SYMomentProfileViewTipsViewRightArrowWH = 15.0f;

/// 说说内容距离顶部的间距 15
CGFloat const SYMomentContentTopInset = 15.0f;
/// 说说内容距离左右屏幕的间距 15
CGFloat const SYMomentContentLeftOrRightInset = 15.0f;

/// 内容（控件）之间的的间距 15
CGFloat const SYMomentContentInnerMargin = 15.0f;

/// 用户头像的大小 45x45
CGFloat const SYMomentAvatarWH = 45.0f;

/// 向上箭头W 45
CGFloat const SYMomentUpArrowViewWidth = 45.0f;
/// 向上箭头H 6
CGFloat const SYMomentUpArrowViewHeight = 6.0f;

/// 全文、收起W
CGFloat const SYMomentExpandButtonWidth = 35.0f;
/// 全文、收起H
CGFloat const SYMomentExpandButtonHeight = 25.0f;

/// pictureView中图片之间的的间距 6
CGFloat const SYMomentPhotosViewItemInnerMargin = 6.0f;
/// pictureView中图片的大小 86x86 (屏幕尺寸>320)
CGFloat const SYMomentPhotosViewItemWH1 = 86.0f;
/// pictureView中图片的大小 70x70 (屏幕尺寸<=320)
CGFloat const SYMomentPhotosViewItemWH2 = 70.0f;

/// 分享内容高度
CGFloat const SYMomentShareInfoViewHeight = 50.0f;

/// videoView高度
CGFloat const SYMomentVideoViewHeight = 181.0f;
/// videoView宽度
CGFloat const SYMomentVideoViewWidth = 103.0f;


/// 微信正文内容的显示最大行数（PS：如果超过最大值，那么正文内容就单行显示，可以点击正文内容查看全部内容）
NSUInteger const SYMomentContentTextMaxCriticalRow = 12000;
/// 微信正文内容显示（全文/收起）的临界行
NSUInteger const SYMomentContentTextExpandCriticalRow = 6;
/// pictureView最多显示的图片数
NSUInteger const SYMomentPhotosMaxCount = 9;


/// 单张图片的最大高度（等比例）180 (ps：别问我为什么，我量出来的)
CGFloat const SYMomentPhotosViewSingleItemMaxHeight = 180;


/// 更多按钮宽高 (实际：25x25)
CGFloat const SYMomentOperationMoreBtnWH = 25;

/// footerViewHeight
CGFloat const SYMomentFooterViewHeight = 15;





//// 评论和点赞view 常量
/// 评论内容距离顶部的间距 5
CGFloat const SYMomentCommentViewContentTopOrBottomInset = 5;
/// 评论内容距离评论View左右屏幕的间距 9
CGFloat const SYMomentCommentViewContentLeftOrRightInset = 9;

/// 点赞内容距离顶部的间距 7
CGFloat const SYMomentCommentViewAttitudesTopOrBottomInset = 7;


/// 更多操作View的Size 181x39
CGFloat const SYMomentOperationMoreViewWidth = 181.0f;
CGFloat const SYMomentOperationMoreViewHeight = 39.0f;

/// 微信动画时间 .25f
NSTimeInterval const SYMommentAnimatedDuration = .2f;


/// 链接key
NSString * const SYMomentLinkUrlKey = @"SYMomentLinkUrlKey";
/// 电话号码key
NSString * const SYMomentPhoneNumberKey = @"SYMomentPhoneNumberKey";
/// 位置key
NSString * const SYMomentLocationNameKey = @"SYMomentLocationNameKey";

/// 用户信息key
NSString * const SYMomentUserInfoKey = @"SYMomentUserInfoKey";


/// 评论View
/** 弹出评论框View最小高度 */
CGFloat const SYMomentCommentToolViewMinHeight = 60;
/** 弹出评论框View最大高度 */
CGFloat const SYMomentCommentToolViewMaxHeight = 130;
/** 弹出评论框View的除了编辑框的高度 */
CGFloat const SYMomentCommentToolViewWithNoTextViewHeight = 20;
