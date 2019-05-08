//
//  SYSingleChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSingleChattingVC.h"
#import "SYNavigationController.h"

@interface SYSingleChattingVC ()



@property (nonatomic, assign) BOOL btnEnabled;

@end

@implementation SYSingleChattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(45, 45);
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
//    [[_sendPresentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        if (self.btnEnabled) {
//            SYGiftVM *giftVM = [[SYGiftVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
//            giftVM.friendId = self.targetId;
//            SYGiftVC *giftVC = [[SYGiftVC alloc] initWithViewModel:giftVM];
//            SYNavigationController *navigationController = [[SYNavigationController alloc]initWithRootViewController:giftVC];
//            CATransition *animation = [CATransition animation];
//            [animation setDuration:0.3];
//            animation.type = kCATransitionFade;
//            [SYSharedAppDelegate presentVC:navigationController withAnimation:animation];
//        }
//    }];
}

- (void)requestGiftList {
    NSDictionary *params = @{@"userId":SYSharedAppDelegate.services.client.currentUser.userId};
    SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_GIFT_LIST_QUERY parameters:subscript.dictionary];
//    [[[[SYSharedAppDelegate.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYGiftModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(SYGiftModel *giftModel) {
//        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
//        [cache setObject:giftModel forKey:@"giftModel"];
//    } error:^(NSError *error) {
//        [MBProgressHUD sy_showErrorTips:error];
//    } completed:^{
//        self.btnEnabled = YES;
//    }];
}

@end
