//
//  SYAnchorShowVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorShowVC.h"

@interface SYAnchorShowVC ()

@end

@implementation SYAnchorShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerView jp_resume];
    NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUser.userId,@"userAnchorId":self.viewModel.model.userId};
    [self.viewModel.requestFocusStateCommand execute:params];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView jp_stopPlay];
}

- (void)bindViewModel {
    @weakify(self)
    [RACObserve(self.viewModel.model, showVideo) subscribeNext:^(NSString *url) {
        @strongify(self)
        [self.playerView jp_playVideoWithURL:[NSURL URLWithString:url] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        }];
    }];
    [RACObserve(self.viewModel.model, userHeadImg) subscribeNext:^(NSString *url) {
        @strongify(self)
        [self.headImageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    }];
    [RACObserve(self.viewModel.model, userName) subscribeNext:^(NSString *alias) {
        @strongify(self)
        self.aliasLabel.text = alias;
    }];
    [RACObserve(self.viewModel.model, userAge) subscribeNext:^(NSString *age) {
        @strongify(self)
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁",age];
    }];
    [RACObserve(self.viewModel, focus) subscribeNext:^(id x) {
        BOOL focus = [x boolValue];
        [self.focusBtn setImage:(focus ? SYImageNamed(@"home_btn_followed") : SYImageNamed(@"home_btn_follow")) forState:UIControlStateNormal];
    }];
    self.backBtn.rac_command = self.viewModel.goBackCommand;
    [[self.focusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUser.userId,@"userAnchorId":self.viewModel.model.userId};
        [self.viewModel.focusAnchorCommand execute:params];
    }];
}

- (void)_setupSubviews {
    self.playerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:self.playerView];
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
    [self.view bringSubviewToFront:containerView];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:SYImageNamed(@"nav_btn_back") forState:UIControlStateNormal];
    _backBtn = backBtn;
    [self.containerView addSubview:backBtn];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 22.5f;
    _headImageView = headImageView;
    [containerView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.font = SYRegularFont(20);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    _aliasLabel = aliasLabel;
    [containerView addSubview:aliasLabel];
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.font = SYRegularFont(18);
    ageLabel.textAlignment = NSTextAlignmentLeft;
    _ageLabel = ageLabel;
    [containerView addSubview:ageLabel];
    
    UIButton *focusBtn = [UIButton new];
    [focusBtn setImage:SYImageNamed(@"home_btn_follow") forState:UIControlStateNormal];
    _focusBtn = focusBtn;
    [containerView addSubview:focusBtn];
    
    UIButton *videoBtn = [UIButton new];
    [videoBtn setImage:SYImageNamed(@"home_btn_videoChat") forState:UIControlStateNormal];
    _videoBtn = videoBtn;
    [containerView addSubview:videoBtn];
}

- (void)_makeSubViewsConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(24);
        make.top.equalTo(self.containerView).offset(40);
        make.left.equalTo(self.containerView).offset(15);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.left.equalTo(self.containerView).offset(20);
        make.bottom.equalTo(self.focusBtn.mas_top).offset(-30);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.ageLabel);
        make.bottom.equalTo(self.ageLabel.mas_top).offset(-10);
        make.height.offset(20);
    }];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView).offset(-5);
        make.height.offset(15);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.containerView).offset(-15);
    }];
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.width.offset(0.26 * SY_SCREEN_WIDTH);
        make.bottom.equalTo(self.containerView).offset(-15);
        make.height.offset(0.1 * SY_SCREEN_WIDTH);
    }];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5 * SY_SCREEN_WIDTH);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.height.equalTo(self.focusBtn);
    }];
}

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return YES;
}
@end
