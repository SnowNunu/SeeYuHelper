//
//  SYWithdrawalVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYWithdrawalVM.h"

@implementation SYWithdrawalVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"提现";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestWithdrawalMoneyInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_WITHDRAW_MONEY_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYWithdrawalModel class]] sy_parsedResults];
    }];
    [self.requestWithdrawalMoneyInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYWithdrawalModel *model) {
        self.model = model;
    }];
    [self.requestWithdrawalMoneyInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterAlipayWithdrawalViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYAlipayWithdrawalVM *vm = [[SYAlipayWithdrawalVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterUnionWithdrawalViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYUnionWithdrawalVM *vm = [[SYUnionWithdrawalVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
