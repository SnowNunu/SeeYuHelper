//
//  SYSingleChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSingleChattingVC.h"
#import "SYGiftVC.h"
#import "SYGiftVM.h"
#import "SYGiftModel.h"
#import "SYNavigationController.h"

@interface SYSingleChattingVC ()

@property (nonatomic, strong) UIButton *sendPresentBtn;

@property (nonatomic, assign) BOOL btnEnabled;

@end

@implementation SYSingleChattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(45, 45);
    [self initSendPresentBtn];
    [self _setupAction];
    self.btnEnabled = NO;
    [self requestGiftList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:PLUGIN_BOARD_ITEM_LOCATION_TAG];
}

- (void)_setupAction {
    @weakify(self)
    [[_sendPresentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.btnEnabled) {
            SYGiftVM *giftVM = [[SYGiftVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
            giftVM.friendId = self.targetId;
            SYGiftVC *giftVC = [[SYGiftVC alloc] initWithViewModel:giftVM];
            SYNavigationController *navigationController = [[SYNavigationController alloc]initWithRootViewController:giftVC];
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.3];
            animation.type = kCATransitionFade;
            [SYSharedAppDelegate presentVC:navigationController withAnimation:animation];
        }
    }];
}

- (void)initSendPresentBtn {
    UIButton *sendPresentBtn = [[UIButton alloc] initWithFrame:CGRectMake(SY_SCREEN_WIDTH - 71, 400, 60, 60)];
    [sendPresentBtn setImage:SYImageNamed(@"message_icon_sendGift") forState:UIControlStateNormal];
    sendPresentBtn.tag = 0;                                                                 
    sendPresentBtn.layer.cornerRadius = 8;
    [self.view addSubview:sendPresentBtn];
    _sendPresentBtn = sendPresentBtn;
    //添加手势
    UIPanGestureRecognizer *panRcognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [sendPresentBtn addGestureRecognizer:panRcognize];
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
                        stopPoint = CGPointMake(recognizer.view.center.x, _sendPresentBtn.width/2.0);
                    } else {
                        stopPoint = CGPointMake(_sendPresentBtn.width/2.0, recognizer.view.center.y);
                    }
                } else {
                    //左下
                    if (recognizer.view.center.x  >= SY_SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SY_SCREEN_HEIGHT - _sendPresentBtn.width/2.0);
                    } else {
                        stopPoint = CGPointMake(_sendPresentBtn.width/2.0, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }
                }
            } else {
                if (recognizer.view.center.y <= SY_SCREEN_HEIGHT/2.0) {
                    //右上
                    if (SY_SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, _sendPresentBtn.width/2.0);
                    } else {
                        stopPoint = CGPointMake(SY_SCREEN_WIDTH - _sendPresentBtn.width/2.0, recognizer.view.center.y);
                    }
                } else {
                    //右下
                    if (SY_SCREEN_WIDTH - recognizer.view.center.x  >= SY_SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SY_SCREEN_HEIGHT - _sendPresentBtn.width/2.0);
                    } else {
                        stopPoint = CGPointMake(SY_SCREEN_WIDTH - _sendPresentBtn.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            //如果按钮超出屏幕边缘
            if (stopPoint.y + _sendPresentBtn.width+40>= SY_SCREEN_HEIGHT) {
                stopPoint = CGPointMake(stopPoint.x, SY_SCREEN_HEIGHT - _sendPresentBtn.width/2.0-49);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - _sendPresentBtn.width/2.0 <= 0) {
                stopPoint = CGPointMake(_sendPresentBtn.width/2.0, stopPoint.y);
            }
            if (stopPoint.x + _sendPresentBtn.width/2.0 >= SY_SCREEN_WIDTH) {
                stopPoint = CGPointMake(SY_SCREEN_WIDTH - _sendPresentBtn.width/2.0, stopPoint.y);
            }
            if (stopPoint.y - _sendPresentBtn.width/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, _sendPresentBtn.width/2.0);
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

- (void)requestGiftList {
    NSDictionary *params = @{@"userId":SYSharedAppDelegate.services.client.currentUser.userId};
    SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_GIFT_LIST_QUERY parameters:subscript.dictionary];
    [[[[SYSharedAppDelegate.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYGiftModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(SYGiftModel *giftModel) {
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        [cache setObject:giftModel forKey:@"giftModel"];
    } error:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    } completed:^{
        self.btnEnabled = YES;
    }];
}

@end
