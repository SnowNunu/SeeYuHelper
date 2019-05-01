//
//  SYConstEnum.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有枚举定义区域

#ifndef SYConstEnum_h
#define SYConstEnum_h

/// tababr item tag
typedef NS_ENUM(NSUInteger, SYTabBarItemTagType) {
    SYTabBarItemTagTypeMainFrame = 0,    /// 首页
    SYTabBarItemTagTypeCollocation,         /// 速配交友
    SYTabBarItemTagTypeContacts,         /// 消息
    SYTabBarItemTagTypeDiscover,         /// 动态
    SYTabBarItemTagTypeProfile,          /// 个人
};


/// 切换根控制器类型
typedef NS_ENUM(NSUInteger, SYSwitchRootViewControllerFromType) {
    SYSwitchRootViewControllerFromTypeNewFeature = 0,  /// 新特性
    SYSwitchRootViewControllerFromTypeLogin,           /// 登录
    SYSwitchRootViewControllerFromTypeLogout,          /// 登出
};

/// 用户登录的渠道
typedef NS_ENUM(NSUInteger, SYUserLoginChannelType) {
    SYUserLoginChannelTypeQQ = 0,           /// qq登录
    SYUserLoginChannelTypeEmail,            /// 邮箱登录
    SYUserLoginChannelTypeWeChatId,         /// 微信号登录
    SYUserLoginChannelTypePhone,            /// 手机号登录
};

/// 用户性别
typedef NS_ENUM(NSUInteger, SYUserGenderType) {
    SYUserGenderTypeMale =0,            /// 男
    SYUserGenderTypeFemale,             /// 女
};

/// 插件详情说明
typedef NS_ENUM(NSUInteger, SYPlugDetailType) {
    SYPlugDetailTypeLook = 0,     /// 看一看
    SYPlugDetailTypeSearch,       /// 搜一搜
};


/// 微信朋友圈类型 （0 配图  1 video 2 share）
typedef NS_ENUM(NSUInteger, SYMomentExtendType) {
    SYMomentExtendTypePicture = 0, /// 配图
    SYMomentExtendTypeVideo,       /// 视频
    SYMomentExtendTypeShare,       /// 分享
};


/// 微信朋友圈分享内容的类型
typedef NS_ENUM(NSUInteger, SYMomentShareInfoType) {
    SYMomentShareInfoTypeWebPage = 0, /// 网页
    SYMomentShareInfoTypeMusic,       /// 音乐
};

#endif /* SYConstEnum_h */
