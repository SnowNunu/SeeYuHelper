//
//  SYChattingListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "JSBadgeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYChattingListCell : RCConversationBaseCell

/// 用户头像
@property (nonatomic, strong) UIImageView *avatarImageView;

/// 用户昵称
@property (nonatomic, strong) UILabel *aliasLabel;

/// 最后一条消息时间
@property (nonatomic, strong) UILabel *timeLabel;

/// 消息内容
@property (nonatomic, strong) UILabel *contentLabel;

/// 角标背景
@property (nonatomic, strong) UIView *badgeBgView;

/// 角标
@property (nonatomic, strong) JSBadgeView *badgeView;

@end

NS_ASSUME_NONNULL_END
