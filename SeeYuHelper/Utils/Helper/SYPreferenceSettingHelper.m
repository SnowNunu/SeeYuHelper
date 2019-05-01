//
//  SYPreferenceSettingHelper.m
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  项目的偏好设置工具类

#import "SYPreferenceSettingHelper.h"
/// 偏好设置
#define SYUserDefaults [NSUserDefaults standardUserDefaults]

/// 存储language
NSString * const SYPreferenceSettingLanguage = @"SYPreferenceSettingLanguage";

/// 存储看一看
NSString * const SYPreferenceSettingLook = @"SYPreferenceSettingLook";
/// 存储看一看（全新）
NSString * const SYPreferenceSettingLookArtboard = @"SYPreferenceSettingLookArtboard";

/// 存储搜一搜
NSString * const SYPreferenceSettingSearch = @"SYPreferenceSettingSearch" ;
/// 存储搜一搜（全新）
NSString * const SYPreferenceSettingSearchArtboard = @"SYPreferenceSettingSearchArtboard" ;


/// ---- 新消息通知
/// 接收新消息通知
NSString * const SYPreferenceSettingReceiveNewMessageNotification = @"SYPreferenceSettingReceiveNewMessageNotification";
/// 接收语音和视频聊天邀请通知
NSString * const SYPreferenceSettingReceiveVoiceOrVideoNotification = @"SYPreferenceSettingReceiveVoiceOrVideoNotification";
/// 视频聊天、语音聊天铃声
NSString * const SYPreferenceSettingVoiceOrVideoChatRing = @"SYPreferenceSettingVoiceOrVideoChatRing" ;
/// 通知显示消息详情
NSString * const SYPreferenceSettingNotificationShowDetailMessage = @"SYPreferenceSettingNotificationShowDetailMessage" ;
/// 消息提醒铃声
NSString * const SYPreferenceSettingMessageAlertVolume = @"SYPreferenceSettingMessageAlertVolume";
/// 消息提醒震动
NSString * const SYPreferenceSettingMessageAlertVibration = @"SYPreferenceSettingMessageAlertVibration";


/// ---- 设置消息免打扰
NSString * const SYPreferenceSettingMessageFreeInterruption = @"SYPreferenceSettingMessageFreeInterruption" ;

/// ---- 隐私
/// 加我为朋友时需要验证
NSString * const SYPreferenceSettingAddFriendNeedVerify = @"SYPreferenceSettingAddFriendNeedVerify";
/// 向我推荐通讯录朋友
NSString * const SYPreferenceSettingRecommendFriendFromContactsList = @"SYPreferenceSettingRecommendFriendFromContactsList";
/// 允许陌生人查看十条朋友圈
NSString * const SYPreferenceSettingAllowStrongerWatchTenMoments = @"SYPreferenceSettingAllowStrongerWatchTenMoments";
/// 开启朋友圈入口
NSString * const SYPreferenceSettingOpenFriendMomentsEntrance = @"SYPreferenceSettingOpenFriendMomentsEntrance";
/// 朋友圈更新提醒
NSString * const SYPreferenceSettingFriendMomentsUpdateAlert = @"SYPreferenceSettingFriendMomentsUpdateAlert";

/// ---- 通用
/// 听筒模式
NSString * const SYPreferenceSettingReceiverMode = @"SYPreferenceSettingReceiverMode";


@implementation SYPreferenceSettingHelper

+ (id)objectForKey:(NSString *)defaultName{
    return [SYUserDefaults objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [SYUserDefaults setObject:value forKey:defaultName];
    [SYUserDefaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [SYUserDefaults boolForKey:defaultName];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [SYUserDefaults setBool:value forKey:defaultName];
    [SYUserDefaults synchronize];
}
@end
