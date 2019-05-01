//
//  SYVideoInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVideoInfoEditVC.h"
#import <YBImageBrowser/YBImageBrowser.h>

@interface SYVideoInfoEditVC ()

@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UILabel *videoTips1Label;

@property (nonatomic, strong) UILabel *videoTips2Label;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *modifyVideoBtn;

@end

@implementation SYVideoInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestUserShowInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, model) subscribeNext:^(SYUserInfoEditModel *model) {
        @strongify(self)
        if (model != nil && ![model.showVideo isEqualToString:@""]) {
            if (model.showVideo == nil || model.showVideo.length == 0) {
                self.videoTips1Label.hidden = NO;
                self.videoTips2Label.hidden = NO;
                self.playBtn.hidden = YES;
                [self.modifyVideoBtn setTitle:@"添加视频" forState:UIControlStateNormal];
            } else {
                self.videoTips1Label.hidden = YES;
                self.videoTips2Label.hidden = YES;
                self.playBtn.hidden = NO;
                [self.modifyVideoBtn setTitle:@"修改视频" forState:UIControlStateNormal];
                self.videoImageView.image = [UIImage sy_thumbnailImageForVideo:[NSURL URLWithString:model.showVideo] atTime:1];;
            }
        }
    }];
    [[self.modifyVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.model.showVideo == nil || ![self.viewModel.model.showVideoStatus isEqualToString:@"0"]) {
            YLShortVideoVC *videoVC = [YLShortVideoVC new];
            videoVC.shortVideoBack = ^(NSURL *videoUrl) {
                self.videoTips1Label.hidden = YES;
                self.videoTips2Label.hidden = YES;
                self.videoImageView.image = [UIImage sy_thumbnailImageForVideo:videoUrl atTime:1];
                [self.viewModel.uploadUserVideoCommand execute:[NSData dataWithContentsOfURL:videoUrl]];
            };
            [self presentViewController:videoVC animated:YES completion:nil];
        } else {
            [MBProgressHUD sy_showTips:@"视频审核中,暂不能修改"];
        }
    }];
    [[self.playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
        data.url = [NSURL URLWithString:self.viewModel.model.showVideo];
        data.sourceObject = self.videoImageView;
        data.autoPlayCount = 1;
        data.allowSaveToPhotoAlbum = NO;
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = @[data];
        browser.currentIndex = 0;
        [browser show];
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    
    UIImageView *videoImageView = [UIImageView new];
    videoImageView.backgroundColor = SYColorAlpha(0, 0, 0, 0.05);
    videoImageView.userInteractionEnabled = YES;
    _videoImageView = videoImageView;
    [self.view addSubview:videoImageView];
    
    UILabel *videoTips1Label = [UILabel new];
    videoTips1Label.textAlignment = NSTextAlignmentCenter;
    videoTips1Label.font = SYRegularFont(30);
    videoTips1Label.text = @"暂无视频";
    videoTips1Label.textColor = SYColor(153, 153, 153);
    _videoTips1Label = videoTips1Label;
    [self.view addSubview:videoTips1Label];
    
    UILabel *videoTips2Label = [UILabel new];
    videoTips2Label.textAlignment = NSTextAlignmentCenter;
    videoTips2Label.font = SYRegularFont(15);
    videoTips2Label.text = @"点击底部按钮添加";
    videoTips2Label.textColor = SYColor(153, 153, 153);
    _videoTips2Label = videoTips2Label;
    [self.view addSubview:videoTips2Label];
    
    UIButton *playBtn = [UIButton new];
    [playBtn setImage:SYImageNamed(@"icon_videoPlay") forState:UIControlStateNormal];
    playBtn.hidden = YES;
    _playBtn = playBtn;
    [videoImageView addSubview:playBtn];
    
    UIButton *modifyVideoBtn = [UIButton new];
    [modifyVideoBtn setTitle:@"添加视频" forState:UIControlStateNormal];
    [modifyVideoBtn setTintColor:[UIColor whiteColor]];
    modifyVideoBtn.titleLabel.font = SYRegularFont(19);
    modifyVideoBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    _modifyVideoBtn = modifyVideoBtn;
    [self.view addSubview:modifyVideoBtn];
}

- (void)_makeSubViewsConstraints {
    [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(self.videoImageView.mas_width);
    }];
    [_videoTips1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImageView);
        make.height.offset(30);
    }];
    [_videoTips2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.videoTips1Label.mas_bottom).offset(15);
        make.centerX.equalTo(self.videoTips1Label);
    }];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImageView);
        make.width.height.offset(80);
    }];
    [_modifyVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.offset(40);
    }];
}

@end
