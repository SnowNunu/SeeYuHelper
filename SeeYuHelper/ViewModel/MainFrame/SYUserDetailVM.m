//
//  SYUserDetailVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYUserDetailVM.h"

@implementation SYUserDetailVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.userId = params[SYViewModelIDKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    @weakify(self)
    self.prefersNavigationBarHidden = YES;
    self.requestUserDetailInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_QUERY parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestUserDetailInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        self.user = user;
    }];
    [self.requestUserDetailInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.sendVideoRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userId) {
        [[RCCall sharedRCCall] startSingleCall:userId mediaType:RCCallMediaVideo];
        return [RACSignal empty];
    }];
}

@end
