//
//  SYFriendDetailInfoVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendDetailInfoVM.h"

@implementation SYFriendDetailInfoVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]) {
        self.userId = params[SYViewModelIDKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarHidden = YES;
    @weakify(self)
    // 返回上一页
    self.goBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    // 请求好友详情
    self.requestFriendDetailInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FRIENDS_DETAIL parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYFriendDetialModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestFriendDetailInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYFriendDetialModel *model) {
        self.friendInfo = model.userBase;
        self.datasource = model.userMoments;
        self.authInfo = model.userAuth;
    }];
    [self.requestFriendDetailInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
