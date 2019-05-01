//
//  SYPrivacyShowVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyShowVM.h"
#import "SYSpeedMatchModel.h"

@implementation SYPrivacyShowVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.model = [SYPrivacyModel yy_modelWithJSON:params[SYViewModelUtilKey]];
    }
    return self;
}

- (void)initialize {
    self.prefersNavigationBarHidden = YES;
    self.interactivePopDisabled = YES;
    @weakify(self)
    self.goBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    self.requestPrivacyStateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"showId":self.model.showId,@"friendUserId":self.model.showUserid};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PRIVACY_DETAIL parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYPrivacyDetailModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestPrivacyStateCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYPrivacyDetailModel *detailModel) {
        self.model.detailModel = detailModel;
    }];
    self.privacyVideoLikedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"showId":self.model.showId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PRIVACY_VIDEO_LIKED parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYPrivacyDetailModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    self.sendAddFriendsRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"firendUserId":self.model.showUserid};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FRIEND_ADD parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYSpeedMatchModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.sendAddFriendsRequestCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYSpeedMatchModel *model) {
        [MBProgressHUD sy_showTips:@"好友请求发送成功"];
    }];
    [self.sendAddFriendsRequestCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
