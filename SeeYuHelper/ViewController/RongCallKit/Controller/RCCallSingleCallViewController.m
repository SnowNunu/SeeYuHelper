//
//  RCCallSingleCallViewController.m
//  RongCallKit
//
//  Created by 岑裕 on 16/3/21.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCCallSingleCallViewController.h"
#import "RCCallFloatingBoard.h"
#import "RCCallKitUtility.h"
#import "RCUserInfoCacheManager.h"
#import "RCloudImageView.h"
#import "JPGiftShowManager.h"
#import "JPGiftModel.h"

@interface RCCallSingleCallViewController ()

@property(nonatomic, strong) RCUserInfo *remoteUserInfo;

@end

@implementation RCCallSingleCallViewController

// init
- (instancetype)initWithIncomingCall:(RCCallSession *)callSession {
    return [super initWithIncomingCall:callSession];
}

- (instancetype)initWithOutgoingCall:(NSString *)targetId mediaType:(RCCallMediaType)mediaType {
    return [super initWithOutgoingCall:ConversationType_PRIVATE
                              targetId:targetId
                             mediaType:mediaType
                            userIdList:@[ targetId ]];
}

- (instancetype)initWithActiveCall:(RCCallSession *)callSession {
    return [super initWithActiveCall:callSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserInfoUpdate:)
                                                 name:RCKitDispatchUserInfoUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showGiftView:)
                                                 name:@"sendGift"
                                               object:nil];

    RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
    if (!userInfo) {
        userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
    }
    self.remoteUserInfo = userInfo;
    [self.remoteNameLabel setText:userInfo.name];
    [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    [self initRequestPresentListBtn];
    [self _setupAction];
}

- (RCloudImageView *)remotePortraitView {
    if (!_remotePortraitView) {
        _remotePortraitView = [[RCloudImageView alloc] init];

        [self.view addSubview:_remotePortraitView];
        _remotePortraitView.hidden = YES;
        [_remotePortraitView setPlaceholderImage:[RCCallKitUtility getDefaultPortraitImage]];
        _remotePortraitView.layer.cornerRadius = 40.f;
        _remotePortraitView.layer.masksToBounds = YES;
    }
    return _remotePortraitView;
}

- (UILabel *)remoteNameLabel {
    if (!_remoteNameLabel) {
        _remoteNameLabel = [[UILabel alloc] init];
        _remoteNameLabel.backgroundColor = [UIColor clearColor];
        _remoteNameLabel.textColor = [UIColor whiteColor];
        _remoteNameLabel.font = [UIFont boldSystemFontOfSize:18];
        _remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_remoteNameLabel];
        _remoteNameLabel.hidden = YES;
    }
    return _remoteNameLabel;
}

- (UIView *)mainVideoView {
    if (!_mainVideoView) {
        _mainVideoView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        _mainVideoView.backgroundColor = RongVoIPUIColorFromRGB(0x262e42);

        [self.backgroundView addSubview:_mainVideoView];
        _mainVideoView.hidden = YES;
    }
    return _mainVideoView;
}

- (UIView *)subVideoView {
    if (!_subVideoView) {
        _subVideoView = [[UIView alloc] init];
        _subVideoView.backgroundColor = [UIColor blackColor];
        _subVideoView.layer.borderWidth = 1;
        _subVideoView.layer.borderColor = [[UIColor whiteColor] CGColor];

        [self.view addSubview:_subVideoView];
        _subVideoView.hidden = YES;

        UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subVideoViewClicked)];
        [_subVideoView addGestureRecognizer:tap];
    }
    return _subVideoView;
}

- (void)subVideoViewClicked {
    if ([self.remoteUserInfo.userId isEqualToString:self.callSession.targetId]) {
        RCUserInfo *userInfo = [RCIMClient sharedRCIMClient].currentUserInfo;

        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];

        [self.callSession setVideoView:self.mainVideoView userId:self.remoteUserInfo.userId];
        [self.callSession setVideoView:self.subVideoView userId:self.callSession.targetId];
    } else {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        if (!userInfo) {
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];

        [self.callSession setVideoView:self.subVideoView userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
        [self.callSession setVideoView:self.mainVideoView userId:self.remoteUserInfo.userId];
    }
}

- (void)resetLayout:(BOOL)isMultiCall mediaType:(RCCallMediaType)mediaType callStatus:(RCCallStatus)callStatus {
    [super resetLayout:isMultiCall mediaType:mediaType callStatus:callStatus];

    UIImage *remoteHeaderImage = self.remotePortraitView.image;

    if (mediaType == RCCallMediaAudio) {
        // 音频通话
        self.remotePortraitView.frame = CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2,
                                                   RCCallVerticalMargin * 3, RCCallHeaderLength, RCCallHeaderLength);
        self.remotePortraitView.image = remoteHeaderImage;
        self.remotePortraitView.hidden = NO;

        self.remoteNameLabel.frame =
            CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                       self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
        self.remoteNameLabel.hidden = NO;

        self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;

        if (callStatus == RCCallRinging || callStatus == RCCallDialing || callStatus == RCCallIncoming) {
            self.remotePortraitView.alpha = 0.5;
        } else {
            self.remotePortraitView.alpha = 1.0;
        }
        self.mainVideoView.hidden = YES;
        self.subVideoView.hidden = YES;
        [self resetRemoteUserInfoIfNeed];
    } else {
        // 视频通话
        if (callStatus == RCCallDialing) {
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.blurView.hidden = YES;
            self.requestGiftListBtn.hidden = YES;
        } else if (callStatus == RCCallActive) {
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView userId:self.callSession.targetId];
            self.blurView.hidden = YES;
            self.requestGiftListBtn.hidden = NO;
        } else {
            self.mainVideoView.hidden = YES;    // 全屏view
            self.requestGiftListBtn.hidden = YES;
        }

        if (callStatus == RCCallActive) {
            self.remotePortraitView.hidden = YES;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        } else if (callStatus == RCCallDialing) {
            // 呼出视频
            self.remotePortraitView.layer.cornerRadius = 25.f;
            [self.remotePortraitView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(15);
                make.top.equalTo(self.view).offset(60);
                make.width.height.offset(50);
            }];
            self.remotePortraitView.image = remoteHeaderImage;
            self.remotePortraitView.hidden = NO;

            self.remoteNameLabel.font = SYRegularFont(16);
            [self.remoteNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.remotePortraitView.mas_right).offset(15);
                make.height.offset(20);
                make.top.equalTo(self.remotePortraitView);
            }];
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentLeft;
        } else if (callStatus == RCCallIncoming || callStatus == RCCallRinging) {
            // 呼入视频请求
            [self.remotePortraitView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.width.height.offset(80);
                make.top.equalTo(self.view).offset(60);
            }];
            self.remotePortraitView.image = remoteHeaderImage;
            self.remotePortraitView.hidden = NO;
            [self.remoteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.remotePortraitView.mas_bottom).offset(15);
                make.height.offset(20);
            }];
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        }

        if (callStatus == RCCallActive) {
            if ([RCCallKitUtility isLandscape] && [self isSupportOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation]) {
                self.subVideoView.frame =
                    CGRectMake(self.view.frame.size.width - RCCallHeaderLength - RCCallHorizontalMargin / 2,
                               RCCallVerticalMargin, RCCallHeaderLength * 1.5, RCCallHeaderLength);
            } else {
                self.subVideoView.frame =
                    CGRectMake(self.view.frame.size.width - RCCallHeaderLength - RCCallHorizontalMargin / 2,
                               RCCallVerticalMargin, RCCallHeaderLength, RCCallHeaderLength * 1.5);
            }
            [self.callSession setVideoView:self.subVideoView userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.subVideoView.hidden = NO;
        } else {
            self.subVideoView.hidden = YES;
        }
        self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        if (callStatus == RCCallRinging || callStatus == RCCallDialing || callStatus == RCCallIncoming) {
            self.remotePortraitView.alpha = 0.5;
        } else {
            self.remotePortraitView.alpha = 1.0;
        }
    }
}

- (void)resetRemoteUserInfoIfNeed {
    if (![self.remoteUserInfo.userId isEqualToString:self.callSession.targetId]) {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        if (!userInfo) {
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    }
}

- (BOOL)isSupportOrientation:(UIInterfaceOrientation)orientation {
    return [[UIApplication sharedApplication]
               supportedInterfaceOrientationsForWindow:[UIApplication sharedApplication].keyWindow] &
           (1 << orientation);
}

#pragma mark - UserInfo Update
- (void)onUserInfoUpdate:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.object;
    NSString *updateUserId = userInfoDic[@"userId"];
    RCUserInfo *updateUserInfo = userInfoDic[@"userInfo"];

    if ([updateUserId isEqualToString:self.remoteUserInfo.userId]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.remoteUserInfo = updateUserInfo;
            [weakSelf.remoteNameLabel setText:updateUserInfo.name];
            [weakSelf.remotePortraitView setImageURL:[NSURL URLWithString:updateUserInfo.portraitUri]];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initRequestPresentListBtn {
    UIButton *requestGiftListBtn = [[UIButton alloc] initWithFrame:CGRectMake(SY_SCREEN_WIDTH - 71, 400, 60, 60)];
    [requestGiftListBtn setImage:SYImageNamed(@"giftList") forState:UIControlStateNormal];
    requestGiftListBtn.tag = 0;
    requestGiftListBtn.layer.cornerRadius = 8;
    [self.view addSubview:requestGiftListBtn];
    _requestGiftListBtn = requestGiftListBtn;
    //添加手势
    UIPanGestureRecognizer *panRcognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [requestGiftListBtn addGestureRecognizer:panRcognize];
}

- (void)_setupAction {
    [[_requestGiftListBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SYGiftListVM *giftListVM = [[SYGiftListVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
        SYGiftListVC *giftListVC = [[SYGiftListVC alloc] initWithViewModel:giftListVM];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        animation.type = kCATransitionFade;
        [SYSharedAppDelegate presentVC:giftListVC withAnimation:animation];
    }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    //移动状态
    UIGestureRecognizerState recState = recognizer.state;
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [recognizer translationInView:self.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint stopPoint = CGPointMake(0, SY_SCREEN_HEIGHT / 2.0);
            if (recognizer.view.center.x < SY_SCREEN_WIDTH / 2.0) {
                if (recognizer.view.center.y <= SY_SCREEN_HEIGHT/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, _requestGiftListBtn.frame.size.width / 2.f);
                    } else {
                        stopPoint = CGPointMake(_requestGiftListBtn.frame.size.width / 2.f, recognizer.view.center.y);
                    }
                } else {
                    //左下
                    if (recognizer.view.center.x  >= SY_SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SY_SCREEN_HEIGHT - _requestGiftListBtn.frame.size.width /2.f);
                    } else {
                        stopPoint = CGPointMake(_requestGiftListBtn.frame.size.width / 2.f, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }
                }
            } else {
                if (recognizer.view.center.y <= SY_SCREEN_HEIGHT / 2.f) {
                    //右上
                    if (SY_SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, _requestGiftListBtn.frame.size.width / 2.f);
                    } else {
                        stopPoint = CGPointMake(SY_SCREEN_WIDTH - _requestGiftListBtn.frame.size.width / 2.f, recognizer.view.center.y);
                    }
                } else {
                    //右下
                    if (SY_SCREEN_WIDTH - recognizer.view.center.x  >= SY_SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SY_SCREEN_HEIGHT - _requestGiftListBtn.frame.size.width/2.f);
                    } else {
                        stopPoint = CGPointMake(SY_SCREEN_WIDTH - _requestGiftListBtn.frame.size.width/2.f,recognizer.view.center.y);
                    }
                }
            }
            //如果按钮超出屏幕边缘
            if (stopPoint.y + _requestGiftListBtn.frame.size.width + 40 >= SY_SCREEN_HEIGHT) {
                stopPoint = CGPointMake(stopPoint.x, SY_SCREEN_HEIGHT - _requestGiftListBtn.frame.size.width/2.f - 49);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - _requestGiftListBtn.frame.size.width / 2.f <= 0) {
                stopPoint = CGPointMake(_requestGiftListBtn.frame.size.width / 2.f, stopPoint.y);
            }
            if (stopPoint.x + _requestGiftListBtn.frame.size.width / 2.f >= SY_SCREEN_WIDTH) {
                stopPoint = CGPointMake(SY_SCREEN_WIDTH - _requestGiftListBtn.frame.size.width / 2.f, stopPoint.y);
            }
            if (stopPoint.y - _requestGiftListBtn.frame.size.width / 2.f <= 0) {
                stopPoint = CGPointMake(stopPoint.x, _requestGiftListBtn.frame.size.width / 2.f);
            }
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)showGiftView:(NSNotification *)notification {
    NSDictionary *params = notification.object;
    JPGiftModel *giftModel = [[JPGiftModel alloc] init];
    giftModel.userIcon = params[@"userHeadImg"];
    giftModel.userName = params[@"userName"];
    giftModel.giftName = params[@"giftName"];
    giftModel.giftImage = params[@"giftImg"];
    giftModel.giftId = params[@"giftId"];
    giftModel.defaultCount = 0;
    giftModel.sendCount = [params[@"giftNum"] intValue];
    [[JPGiftShowManager sharedManager] showGiftViewWithBackView:self.view info:giftModel completeBlock:^(BOOL finished) {
        //结束
    }];
}

@end
