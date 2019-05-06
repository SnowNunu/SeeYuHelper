//
//  SYPaymentsDetailVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPaymentsDetailVM.h"

@implementation SYPaymentsDetailVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.type = params[SYViewModelIDKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"收支明细";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestPaymentsDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        subscript[@"type"] = self.type;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PAYMENTS_DETAIL_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYPaymentsModel class]] sy_parsedResults];
    }];
    [self.requestPaymentsDetailCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYPaymentsModel *model) {
        self.model = model;
    }];
    [self.requestPaymentsDetailCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
