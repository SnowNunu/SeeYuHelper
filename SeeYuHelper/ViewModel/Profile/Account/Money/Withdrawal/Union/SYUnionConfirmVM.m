//
//  SYUnionConfirmVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYUnionConfirmVM.h"

@implementation SYUnionConfirmVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.confirmInfo = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"提现信息";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.withdrawalUnionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_WITHDRAW_MONEY_REQUEST parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYObject class]] sy_parsedResults];
    }];
    [self.withdrawalUnionCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        [MBProgressHUD sy_showTips:@"提现申请成功"];
        [self.services popViewModelAnimated:YES];
    }];
    [self.withdrawalUnionCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
