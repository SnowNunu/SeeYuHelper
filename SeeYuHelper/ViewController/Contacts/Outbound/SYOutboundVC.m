//
//  SYOutboundVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYOutboundVC.h"
#import <AVFoundation/AVFoundation.h>
#import "JPVideoPlayerKit.h"
#import "SYOutboundModel.h"

@interface SYOutboundVC ()

// 视频播放页面
@property (nonatomic, strong) UIView *videoShowView;

// 控制面板
@property (nonatomic, strong) UIView *controlPanelView;

// 头像
@property (nonatomic, strong) UIImageView *headImageView;

// 用户昵称
@property (nonatomic, strong) UILabel *aliasLabel;

// 提示文本
@property (nonatomic, strong) UILabel *tipsLabel;

// 挂断按钮
@property (nonatomic, strong) UIButton *hangUpBtn;

// 呼叫时间文本
@property (nonatomic, strong) UILabel *timeLabel;

// 接听按钮
@property (nonatomic, strong) UIButton *answerBtn;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation SYOutboundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, model) subscribeNext:^(SYOutboundModel *model) {
        @strongify(self)
        if (model != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.videoShowView jp_playVideoWithURL:[NSURL URLWithString:model.videoShow] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
                    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.avatarImage] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
                    self.aliasLabel.text = model.alias;
                    [self startCallShow];
                    [self startTimer];
                }];
            });
        }
    }];
    [[self.hangUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        [self stopCallShow];
    }];
}

- (void)_setupSubviews {
    UIView *videoShowView = [UIView new];
    videoShowView.backgroundColor = SYColorFromHexString(@"#262E42");
    _videoShowView = videoShowView;
    [self.view addSubview:videoShowView];
    
    UIView *controlPanelView = [UIView new];
    controlPanelView.backgroundColor = [UIColor clearColor];
    _controlPanelView = controlPanelView;
    [self.view addSubview:controlPanelView];
    [self.view bringSubviewToFront:self.controlPanelView];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 40;
    _headImageView = headImageView;
    [controlPanelView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.textAlignment = NSTextAlignmentCenter;
    aliasLabel.font = SYRegularFont(18);
    _aliasLabel = aliasLabel;
    [controlPanelView addSubview:aliasLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"邀请你进行视频聊天\n\n对方正在等待...";
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.numberOfLines = 0;
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.font = SYRegularFont(14);
    _tipsLabel = tipsLabel;
    [controlPanelView addSubview:tipsLabel];
    
    UIButton *hangUpBtn = [UIButton new];
    [hangUpBtn setImage:SYImageNamed(@"hang_up") forState:UIControlStateNormal];
    _hangUpBtn = hangUpBtn;
    [controlPanelView addSubview:hangUpBtn];
    
    UIButton *answerBtn = [UIButton new];
    [answerBtn setImage:SYImageNamed(@"answer_hover") forState:UIControlStateNormal];
    _answerBtn = answerBtn;
    [controlPanelView addSubview:answerBtn];
}

- (void)_makeSubViewsConstraints {
    [_videoShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_controlPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoShowView);
    }];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(80);
        make.centerX.equalTo(self.controlPanelView);
        make.top.equalTo(self.controlPanelView).offset(60);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.controlPanelView);
        make.height.offset(20);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.controlPanelView);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
        make.height.offset(65);
    }];
    [_hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.bottom.equalTo(self.view).offset(-45);
        make.left.equalTo(self.controlPanelView).offset(60);
    }];
    [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.equalTo(self.hangUpBtn);
        make.right.equalTo(self.controlPanelView).offset(-60);
    }];
}

- (void)startPlayRing:(NSString *)ringPath {
    if (ringPath) {
        if (self.audioPlayer) {
            [self stopPlayRing];
        }
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        if (self.callSession.callStatus == RCCallDialing) {
//            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//        } else {
//            //默认情况按静音或者锁屏键会静音
        [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [self triggerVibrate];
//        }
        [audioSession setActive:YES error:nil];
        NSURL *url = [NSURL URLWithString:ringPath];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (!error) {
            self.audioPlayer.numberOfLoops = -1;
            self.audioPlayer.volume = 1.0;
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
        }
    }
}

- (void)stopPlayRing {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerVibrate) object:nil];
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        //设置铃声停止后恢复其他app的声音
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                             error:nil];
    }
}

// 震动
- (void)triggerVibrate {
    __weak typeof(self) weakSelf = self;
    if (SYIOSVersion >= 9.0) {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf performSelector:@selector(triggerVibrate) withObject:nil afterDelay:2];
            });
        });
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self performSelector:@selector(triggerVibrate) withObject:nil afterDelay:2];
    }
}

- (void)startCallShow {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Opening" ofType:@"m4r"];
    [self startPlayRing:filePath];
}

- (void)stopCallShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"stopCallShow"];
        [self.videoShowView jp_stopPlay];
        [self stopPlayRing];
        [SYSharedAppDelegate dismissVC:self];
    });
}

- (void)startTimer {
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"stopCallShow" timeInterval:[self.viewModel.model.interval doubleValue]  queue:dispatch_get_main_queue() repeats:NO fireInstantly:NO action:^{
        [self stopCallShow];
    }];
}

@end
