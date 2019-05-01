//
//  SYPrivacyShowVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYPrivacyShowVM.h"
#import "JPVideoPlayerKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPrivacyShowVC : SYVC

@property (nonatomic, strong) SYPrivacyShowVM *viewModel;

// 视频播放器view
@property (nonatomic, strong) UIView *playerView;

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

// 控制面板
@property (nonatomic, strong) UIView *containerView;

// 好友头像
@property (nonatomic, strong) UIImageView *headImageView;

// 添加好友按钮
@property (nonatomic, strong) UIButton *addFriendsBtn;

// 点赞按钮
@property (nonatomic, strong) UIButton *likeBtn;

// 点赞数量文本
@property (nonatomic, strong) UILabel *likeLabel;

// 评论按钮
@property (nonatomic, strong) UIButton *discussBtn;

// 评论数量文本
//@property (nonatomic, strong) UILabel *discussLabel;

// 视频按钮
@property (nonatomic, strong) UIButton *videoBtn;

// 与TA视频文本
@property (nonatomic, strong) UILabel *videoLabel;

// 昵称
@property (nonatomic, strong) UILabel *aliasLabel;

// 签名
@property (nonatomic, strong) UILabel *signatureLabel;

@end

NS_ASSUME_NONNULL_END
