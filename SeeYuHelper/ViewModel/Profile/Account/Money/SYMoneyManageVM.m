//
//  SYMoneyManageVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMoneyManageVM.h"

@implementation SYMoneyManageVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"资金管理";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestMoneyManageInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MONEY_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYMoneyInfoModel class]] sy_parsedResults];
    }];
    [self.requestMoneyManageInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYMoneyInfoModel *moneyInfo) {
        self.moneyInfo = moneyInfo;
    }];
    [self.requestMoneyManageInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterWithdrawalViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYWithdrawalVM *vm = [[SYWithdrawalVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
