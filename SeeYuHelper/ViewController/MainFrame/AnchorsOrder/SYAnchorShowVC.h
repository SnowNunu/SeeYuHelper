//
//  SYAnchorShowVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYAnchorShowVM.h"
#import "JPVideoPlayerKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorShowVC : SYVC <JPVideoPlayerDelegate>

@property (nonatomic, strong) SYAnchorShowVM *viewModel;

// 视频播放器view
@property (nonatomic, strong) UIView *playerView;

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

// 控制面板
@property (nonatomic, strong) UIView *containerView;

// 头像
@property (nonatomic, strong) UIImageView *headImageView;

// 昵称
@property (nonatomic, strong) UILabel *aliasLabel;

// 年龄
@property (nonatomic, strong) UILabel *ageLabel;

// 关注按钮
@property (nonatomic, strong) UIButton *focusBtn;

// 发起视频按钮
@property (nonatomic, strong) UIButton *videoBtn;

@end

NS_ASSUME_NONNULL_END
