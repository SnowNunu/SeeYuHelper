//
//  SYMainFrameVM.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYMainFrameVM.h"

@interface SYMainFrameVM ()

@end


@implementation SYMainFrameVM

- (void)initialize {
    @weakify(self)
    [super initialize];
    self.title = @"首页";
    self.requestUserListInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllUserInfo)(NSArray *) = ^(NSArray *userInfo) {
            return userInfo.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTP_PATH_USER_INFO_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUserListModel class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal] map:mapAllUserInfo];
    }];
    self.requestCustomerServiceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTP_PATH_CUSTOMER_SERVICE_INFO parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUserListModel class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestCustomerServiceCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUserListModel *model) {
        YYCache *cache = [YYCache cacheWithName:@"SeeYuHelper"];
        [cache setObject:model.customerUserId forKey:@"customerUserId"];
    }];
    [self.requestCustomerServiceCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    [self.requestUserListInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestUserListInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterUserInfoViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userId) {
        SYUserDetailVM *vm = [[SYUserDetailVM alloc] initWithServices:self.services params:@{SYViewModelIDKey:userId}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}
@end


