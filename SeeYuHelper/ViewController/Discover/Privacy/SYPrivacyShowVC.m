//
//  SYPrivacyShowVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyShowVC.h"
#import "SYRCIMDataSource.h"
#import "SYSingleChattingVC.h"

@interface SYPrivacyShowVC ()

@end

@implementation SYPrivacyShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel.requestPrivacyStateCommand execute:nil];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerView jp_resume];
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
    [RACObserve(self.viewModel.model, userHeadImg) subscribeNext:^(NSString *userHeadImg) {
        @strongify(self)
        if (![userHeadImg sy_isNullOrNil] && userHeadImg.length > 0) {
            [self.headImageView yy_setImageWithURL:[NSURL URLWithString:userHeadImg] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
        }
    }];
    [RACObserve(self.viewModel.model, userName) subscribeNext:^(NSString *userName) {
        @strongify(self)
        if (![userName sy_isNullOrNil] && userName.length > 0) {
            self.aliasLabel.text = userName;
        }
    }];
    [RACObserve(self.viewModel.model, userSignature) subscribeNext:^(NSString *signature) {
        @strongify(self)
        if (![signature sy_isNullOrNil] && signature.length > 0) {
            self.signatureLabel.text = signature;
        }
    }];
    [RACObserve(self.viewModel.model, detailModel) subscribeNext:^(SYPrivacyDetailModel *detailModel) {
        @strongify(self)
        if (detailModel != nil) {
            if (![detailModel.likedCount sy_isNullOrNil] && detailModel.likedCount.length > 0) {
                self.likeLabel.text = detailModel.likedCount;
            }
            if (![detailModel.liked sy_isNullOrNil] && detailModel.liked.length > 0) {
                if ([detailModel.liked isEqualToString:@"0"]) {
                    self.likeBtn.selected = NO;
                } else {
                    self.likeBtn.selected = YES;
                }
            }
        }
    }];
    self.backBtn.rac_command = self.viewModel.goBackCommand;
    [self.viewModel.privacyVideoLikedCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYPrivacyDetailModel *model) {
        if ([model.liked isEqualToString:@"0"]) {
            self.likeBtn.selected = NO;
        } else {
            self.likeBtn.selected = YES;
        }
        if (![model.likedCount sy_isNullOrNil] && model.likedCount.length > 0) {
            self.likeLabel.text = model.likedCount;
        }
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
    headImageView.layer.cornerRadius = 22.f;
    _headImageView = headImageView;
    [self.containerView addSubview:headImageView];
    
    UIButton *addFriendsBtn = [UIButton new];
    [addFriendsBtn setImage:SYImageNamed(@"news_profile_border") forState:UIControlStateNormal];
    addFriendsBtn.rac_command = self.viewModel.sendAddFriendsRequestCommand;
    _addFriendsBtn = addFriendsBtn;
    [self.containerView addSubview:addFriendsBtn];
    [self.containerView bringSubviewToFront:addFriendsBtn];
    
    UIButton *likeBtn = [UIButton new];
    [likeBtn setImage:SYImageNamed(@"news_like_normal") forState:UIControlStateNormal];
    [likeBtn setImage:SYImageNamed(@"news_like_pressed") forState:UIControlStateSelected];
    likeBtn.rac_command = self.viewModel.privacyVideoLikedCommand;
    _likeBtn = likeBtn;
    [self.containerView addSubview:likeBtn];
    
    UILabel *likeLabel = [UILabel new];
    likeLabel.textColor = [UIColor whiteColor];
    likeLabel.textAlignment = NSTextAlignmentCenter;
    likeLabel.font = SYRegularFont(12);
    _likeLabel = likeLabel;
    [self.containerView addSubview:likeLabel];
    
    UIButton *discussBtn = [UIButton new];
    [discussBtn setImage:SYImageNamed(@"news_message") forState:UIControlStateNormal];
    [[discussBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.viewModel.model.detailModel.isFriend isEqualToString:@"0"]) {
            // 不是好友关系
            [MBProgressHUD sy_showTips:@"请先添加对方为好友"];
        } else {
            [[SYRCIMDataSource shareInstance] getUserInfoWithUserId:self.viewModel.model.showUserid completion:^(RCUserInfo * _Nonnull userInfo) {
                SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = userInfo.userId;
                conversationVC.title = userInfo.name;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }];
        }
    }];
    _discussBtn = discussBtn;
    [self.containerView addSubview:discussBtn];
    
//    UILabel *discussLabel = [UILabel new];
//    discussLabel.textColor = [UIColor whiteColor];
//    discussLabel.textAlignment = NSTextAlignmentCenter;
//    discussLabel.font = SYRegularFont(12);
//    discussLabel.text = @"12138";
//    _discussLabel = discussLabel;
//    [self.containerView addSubview:discussLabel];
    
    UIButton *videoBtn = [UIButton new];
    [videoBtn setImage:SYImageNamed(@"news_live") forState:UIControlStateNormal];
    _videoBtn = videoBtn;
    [self.containerView addSubview:videoBtn];
    
    UILabel *videoLabel = [UILabel new];
    videoLabel.textColor = [UIColor whiteColor];
    videoLabel.textAlignment = NSTextAlignmentCenter;
    videoLabel.font = SYRegularFont(12);
    videoLabel.text = @"与TA视频";
    _videoLabel = videoLabel;
    [self.containerView addSubview:videoLabel];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font = SYRegularFont(17);
    _aliasLabel = aliasLabel;
    [self.containerView addSubview:aliasLabel];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textColor = [UIColor whiteColor];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.font = SYRegularFont(15);
    _signatureLabel = signatureLabel;
    [self.containerView addSubview:signatureLabel];
}

- (void)_makeSubViewsConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.top.equalTo(self.containerView).offset(40);
        make.left.equalTo(self.containerView).offset(15);
    }];
    [self.addFriendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.right.equalTo(self.containerView).offset(-15);
        make.bottom.equalTo(self.likeBtn.mas_top).offset(-10);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.addFriendsBtn);
        make.width.height.offset(44);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.right.equalTo(self.containerView).offset(-15);
        make.bottom.equalTo(self.likeLabel.mas_top);
    }];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBtn);
        make.height.offset(20);
        make.width.offset(100);
        make.bottom.equalTo(self.discussBtn.mas_top).offset(-15);
    }];
    [self.discussBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.right.equalTo(self.containerView).offset(-15);
        make.bottom.equalTo(self.videoBtn.mas_top).offset(-15);
    }];
//    [self.discussLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.videoBtn);
//        make.height.offset(20);
//        make.width.offset(100);
//        make.bottom.equalTo(self.videoBtn.mas_top).offset(-15);
//    }];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.right.equalTo(self.containerView).offset(-15);
        make.bottom.equalTo(self.videoLabel.mas_top);
    }];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBtn);
        make.height.offset(20);
        make.width.offset(100);
        make.bottom.equalTo(self.aliasLabel.mas_top).offset(-15);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.signatureLabel);
        make.bottom.equalTo(self.signatureLabel.mas_top).offset(-15);
        make.height.offset(15);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.bottom.equalTo(self.containerView).offset(-80);
        make.height.offset(15);
        make.right.equalTo(self.containerView).offset(-15);
    }];
}

@end
