//
//  SYUser.h
//  WeChat
//
//  Created by senba on 2017/10/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  用户信息模型

#import "SYObject.h"
#import "SYAuthenticationModel.h"

@interface SYUser : SYObject

/** 用户ID */
@property (nonatomic, strong) NSString *userId;

/** 用户昵称 */
@property (nonatomic, strong) NSString *userName;

/** 密码 */
@property (nonatomic, strong) NSString *userPassword;

/** 年龄 */
@property (nonatomic, strong) NSString *userAge;

/** 性别 */
@property (nonatomic, strong) NSString *userGender;

/** 职业 */
@property (nonatomic, strong) NSString *userProfession;

/** 收入 */
@property (nonatomic, strong) NSString *userIncome;

/** 身高 */
@property (nonatomic, strong) NSString *userHeight;

/** 结婚状态 */
@property (nonatomic, strong) NSString *userMarry;

/** 特长 */
@property (nonatomic, strong) NSString *userSpecialty;

/** 用户城市地址 */
@property (nonatomic, strong) NSString *userAddress;

/** 用户签名 */
@property (nonatomic, strong) NSString *userSignature;

/** 播币 */
@property (nonatomic, assign) int userCoin;

/** 钻石 */
@property (nonatomic, assign) int userDiamond;

/** 用户幸福值 */
@property (nonatomic, assign) int userHappinessValue;

/** 注册时间 */
@property (nonatomic, strong) NSDate *userRegisterTime;

/** 注册ip */
@property (nonatomic, strong) NSString *userRegisterIp;

/** 用户渠道 */
@property (nonatomic, strong) NSString *userChannelid;

/** 用户是否为vip 0 不是 1 是 2 终身会员 */
@property (nonatomic, assign) int userVipStatus;

/** 到期时间 */
@property (nonatomic, strong) NSDate *userVipExpiresAt;

/** 头像 */
@property (nonatomic, strong) NSString *userHeadImg;

/** token */
@property (nonatomic, strong) NSString *userToken;

/** 学历 */
@property (nonatomic, strong) NSString *userEdu;

/** 生日 */
@property (nonatomic, strong) NSString *userBirthday;

/** 体重 */
@property (nonatomic, strong) NSString *userWeight;

/** 星座 */
@property (nonatomic, strong) NSString *userConstellation;

/** 好友位置 默认为用户当前位置*/
@property (nonatomic, strong) NSString *userLocation;

/** 好友距离 */
@property (nonatomic, assign) float userDistance;

/** 用户认证状态 */
@property (nonatomic, assign) int identityStatus;

/** 用户在线状态 */
@property (nonatomic, strong) NSString *userOnline;

/** 用户展示视频 */
@property (nonatomic, strong) NSString *showVideo;

//------------------------------------------------------------------
/// ----- 登录相关 -----
/// qq
@property (nonatomic, readwrite, copy) NSString *qq;
/// 邮箱
@property (nonatomic, readwrite, copy) NSString *email;
/// 微信号
@property (nonatomic, readwrite, copy) NSString *wechatId;
/// 手机号码
@property (nonatomic, readwrite, copy) NSString *phone;

/// 登录渠道
@property (nonatomic, readwrite, assign) SYUserLoginChannelType channel;

@end
