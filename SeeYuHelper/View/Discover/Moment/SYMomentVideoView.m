//
//  SYMomentVideoView.m
//  WeChat
//
//  Created by senba on 2018/2/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYMomentVideoView.h"

@interface SYMomentVideoView ()

/// coverView
@property (nonatomic, readwrite, weak) UIImageView *coverView;

/// playBtn
@property (nonatomic, readwrite, weak) UIButton *playBtn;

@end


@implementation SYMomentVideoView

+ (instancetype)videoView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化
- (void)_setup
{
    
}

#pragma mark - 初始化子空间
- (void)_setupSubViews{
    /// avatarView
    UIImageView *coverView = [[UIImageView alloc] init];
    coverView.userInteractionEnabled = YES;
    self.coverView = coverView;
    [self addSubview:coverView];
    
    
    /// 播放按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:SYImageNamed(@"Fav_List_Video_Play_40x40") forState:UIControlStateNormal];
    [playBtn setImage:SYImageNamed(@"Fav_List_Video_Play_HL_40x40") forState:UIControlStateHighlighted];
    self.playBtn = playBtn;
    [coverView addSubview:playBtn];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


@end
