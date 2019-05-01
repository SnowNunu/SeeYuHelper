//
//  SYChattingListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYChattingListCell.h"

@implementation SYChattingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    // 用户头像
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.layer.cornerRadius = 22.5f;
    avatarImageView.clipsToBounds = YES;    // 子视图超过父视图部分进行裁剪
    _avatarImageView = avatarImageView;
    [self.contentView addSubview:avatarImageView];
    
    // 用户昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.font = SYRegularFont(18);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.textColor = SYColor(51, 51, 51);
    _aliasLabel = aliasLabel;
    [self.contentView addSubview:aliasLabel];
    
    // 消息内容
    UILabel *contentLabel = [UILabel new];
    contentLabel.font = SYRegularFont(14);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = SYColor(153, 153, 153);
    _contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    // 最后一条消息时间
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = SYRegularFont(14);
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = SYColor(153, 153, 153);
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    // 角标背景
    UIView *badgeBgView = [UIView new];
    badgeBgView.backgroundColor = [UIColor clearColor];
    _badgeBgView = badgeBgView;
    [self.contentView addSubview:badgeBgView];
    [self.contentView bringSubviewToFront:badgeBgView];
    
    // 未读消息数角标
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:badgeBgView alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeBackgroundColor = [UIColor redColor];   //setting color
    badgeView.badgePositionAdjustment = CGPointMake(0, 5); //微调小红点位置
    badgeView.badgeOverlayColor = [UIColor clearColor]; //设置外圈颜色
    badgeView.badgeStrokeColor = [UIColor redColor];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    _badgeView = badgeView;
}

- (void)_makeSubViewsConstraints {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView);
        make.height.offset(20);
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView);
        make.height.left.equalTo(self.aliasLabel);
        make.right.equalTo(self.timeLabel.mas_left).offset(-15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.avatarImageView);
        make.height.offset(20);
    }];
    [self.badgeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.avatarImageView);
    }];
}

@end
