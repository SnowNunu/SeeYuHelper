//
//  SYURLParameters.h
//  WeChat
//
//  Created by senba on 2017/7/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  网络服务层 -参数

#import <Foundation/Foundation.h>
#import "SYKeyedSubscript.h"
#import "SYHTTPServiceConstant.h"


/// 请求Method
/// GET 请求
#define SY_HTTTP_METHOD_GET @"GET"
/// HEAD
#define SY_HTTTP_METHOD_HEAD @"HEAD"
/// POST
#define SY_HTTTP_METHOD_POST @"POST"
/// PUT
#define SY_HTTTP_METHOD_PUT @"PUT"
/// POST
#define SY_HTTTP_METHOD_PATCH @"PATCH"
/// DELETE
#define SY_HTTTP_METHOD_DELETE @"DELETE"

/*-----------请求path---------------*/

/// 用户注册接口
#define SY_HTTTP_PATH_USER_REGISTER     @"/application/user/register"

/// 登录上报接口
#define SY_HTTTP_PATH_LOGIN_REPORT     @"/application/user/loginByUserId"

/// 获取用户资料
#define SY_HTTTP_PATH_USER_INFO_QUERY   @"/application/user/query"

/// 获取用户展示资料
#define SY_HTTTP_PATH_USER_COVER_QUERY   @"/application/userShow/queryMineShow"

/// 获取当前用户的全部动态
#define SY_HTTTP_PATH_USER_MINE_MOMENTS_QUERY   @"/application/userMoment/queryMineMoments"

/// 获取IM用户资料
#define SY_HTTTP_PATH_USER_IMINFO   @"/application/user/iminfo"

/// 更新用户资料
#define SY_HTTTP_PATH_USER_INFO_UPDATE  @"/application/user/update"

/// 头像上传
#define SY_HTTTP_PATH_USER_HEAD_UPLOAD  @"/application/user/headimage/upload"

/// 封面或视频上传
#define SY_HTTTP_PATH_USER_SHOW_UPLOAD  @"/application/userShow/addShow"

/// 用户日常签到
#define SY_HTTTP_PATH_USER_SIGN  @"/application/user/userSign"

/// 获取日常签到情况
#define SY_HTTTP_PATH_USER_SIGN_INFO @"/application/user/userSignRecord"

/// 获取新手礼包详情接口
#define SY_HTTTP_PATH_GIFT_PACKAGE_INFO @"/application/newGiftPackage/queryNewGiftPackage"

/// 领取新手礼包接口
#define SY_HTTTP_PATH_GIFT_PACKAGE_RECEIVE @"application/newGiftPackage/receiveNewGiftPackage"

/// 获取用户认证状态
#define SY_HTTTP_PATH_USER_IDENTITY_SATUS  @"/application/user/queryAuth"

/// 实名认证信息上传
#define SY_HTTTP_PATH_USER_IDENTITY_UPLOAD @"/application/userIdentityAuth/addUserIdentity"

/// 自拍认证信息上传
#define SY_HTTTP_PATH_USER_SELFIE_UPLOAD @"/application/userSelfieAuth/addUserSelfie"

/// 获取附近的人
#define SY_HTTTP_PATH_USER_NEARBY   @"/application/user/nearby"

/// 获取所有的爱好标签
#define SY_HTTTP_PATH_USER_HOBBIES   @"/application/userHobby/queryHobbies"

/// 机器人推送
#define SY_HTTTP_PATH_PUSH_REBOT    @"/application/push/rebot"

/// 发送手机验证码
#define SY_HTTTP_PATH_USER_AUTH_CODE   @"/application/user/sendPIN"

/// 手机验证码登录
#define SY_HTTTP_PATH_USER_AUTH_LOGIN   @"/application/user/loginByMobile"

/// 绑定手机号
#define SY_HTTTP_PATH_USER_MOBILE_BIND   @"/application/user/bingingMobile"

/// 获取用户的好友列表
#define SY_HTTTP_PATH_USER_FRIENDS_LIST   @"/application/userFriendRelation/queryFriendList"

/// 获取用户钻石和服务器端礼物列表
#define SY_HTTTP_PATH_USER_GIFT_LIST_QUERY   @"/application/gift/queryGifts"

#define SY_HTTTP_PATH_USER_GIFT_SEND        @"/application/giveGift/giveGift"

/// 按昵称或者id搜索好友
#define SY_HTTTP_PATH_USER_FRIENDS_SEARCH   @"/application/user/searchUser"

/// 查询所有的好友请求列表
#define SY_HTTTP_PATH_USER_NEW_FRIENDS_LIST   @"/application/userFriendRelation/queryNewFriendList"

/// 获取主播列表
#define SY_HTTTP_PATH_USER_ANCHOR_LIST   @"/application/userAnchor/queryAnchors"

/// 获取选聊主播(在线)列表
#define SY_HTTTP_PATH_USER_ANCHOR_ONLINE_LIST  @"/application/userAnchor/chooseChatAnchors"

/// 获取礼物列表
#define SY_HTTTP_PATH_USER_PRESENTS_LIST        @"/application/giveGift/queryGiveOrReceiveGift"

/// 获取当前主播的关注状态
#define SY_HTTTP_PATH_ANCHOR_FOCUS_STATE   @"/application/userAnchor/queryFollowFlag"

/// 关注或取关当前主播
#define SY_HTTTP_PATH_ANCHOR_FOCUS_EXECUTE    @"/application/userAnchor/userFollowAnchor"

/// 获取榜单列表
#define SY_HTTTP_PATH_RANKING_LIST          @"/application/user/queryTopList"

/// 获取速配好友列表
#define SY_HTTTP_PATH_USER_MATCH_SPEED_LIST     @"/application/user/querySpeedMatch"

// 添加好友
#define SY_HTTTP_PATH_USER_FRIEND_ADD        @"/application/userFriendRelation/addFriend"

// 同意好友请求
#define SY_HTTTP_PATH_USER_FRIEND_AGREE   @"/application/userFriendRelation/agreeAddFriend"

/// 获取私密列表
#define SY_HTTTP_PATH_USER_PRIVACY_LIST     @"/application/userShow/queryPrivateArea"

/// 获取私密用户关注详情
#define SY_HTTTP_PATH_USER_PRIVACY_DETAIL     @"/application/userShow/privateAreaDetail"

/// 私密用户封面视频点赞
#define SY_HTTTP_PATH_USER_PRIVACY_VIDEO_LIKED  @"/application/userShow/likeShowVideo"

// 获取会员动态
#define SY_HTTTP_PATH_USER_MOMENTS_LIST     @"/application/userMoment/queryMoments"

// 获取好友详情
#define SY_HTTTP_PATH_USER_FRIENDS_DETAIL     @"/application/user/queryPersonalPage"

// 获取论坛列表
#define SY_HTTTP_PATH_USER_FORUM_LIST     @"/application/forum/queryForums"

// 获取论坛列表
#define SY_HTTTP_PATH_USER_FORUM_COMMENT_LIST     @"/application/forumComment/queryForumComment"

// 发表评论
#define SY_HTTTP_PATH_USER_FORUM_COMMENT_POST     @"/application/forumComment/addForumComment"

// 点赞评论
#define SY_HTTTP_PATH_USER_FORUM_COMMENT_LIKE     @"/application/forumComment/likeForumComment"


///
//+ (NSString *)ver;          // app版本号
//+ (NSString *)token;        // token，默认空字符串
//+ (NSString *)deviceid;     // 设备编号，自行生成
//+ (NSString *)platform;     // 平台 pc,wap,android,iOS
//+ (NSString *)channel;      // 渠道 AppStore
//+ (NSString *)t;            // 当前时间戳

/// 项目额外的配置参数拓展 (PS)开发人员无需考虑
@interface SBURLExtendsParameters : NSObject

/// 类方法
+ (instancetype)extendsParameters;

/// 用户token，默认空字符串
@property (nonatomic, readonly, copy) NSString *token;

/// 设备编号，自行生成
@property (nonatomic, readonly, copy) NSString *deviceid;

/// app版本号
@property (nonatomic, readonly, copy) NSString *ver;

/// 平台 pc,wap,android,iOS
@property (nonatomic, readonly, copy) NSString *platform;

/// 渠道 AppStore
@property (nonatomic, readonly, copy) NSString *channel;

/// 时间戳
@property (nonatomic, readonly, copy) NSString *t;

@end


@interface SYURLParameters : NSObject
/// 路径 （v14/order）
@property (nonatomic, readwrite, strong) NSString *path;
/// 参数列表
@property (nonatomic, readwrite, strong) NSDictionary *parameters;
/// 方法 （POST/GET）
@property (nonatomic, readwrite, strong) NSString *method;
/// 拓展的参数属性 (开发人员不必关心)
@property (nonatomic, readwrite, strong) SBURLExtendsParameters *extendsParameters;

/**
 参数配置（统一用这个方法配置参数） （SBBaseUrl : https://api.cleancool.tenqing.com/）
 https://api.cleancool.tenqing.com/user/info?user_id=100013
 @param method 方法名 （GET/POST/...）
 @param path 文件路径 （user/info）
 @param parameters 具体参数 @{user_id:10013}
 @return 返回一个参数实例
 */
+(instancetype)urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;

@end
