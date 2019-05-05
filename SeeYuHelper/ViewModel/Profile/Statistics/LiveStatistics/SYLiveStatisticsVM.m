//
//  SYLiveStatisticsVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLiveStatisticsVM.h"

@implementation SYLiveStatisticsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"直播数据";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.reuqestLiveInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_LIVE_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYLiveInfoModel class]] sy_parsedResults];
    }];
    [self.reuqestLiveInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYLiveInfoModel *liveInfo) {
        self.liveInfo = liveInfo;
    }];
    [self.reuqestLiveInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterLiveDetailViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYLiveDetailsVM *vm = [[SYLiveDetailsVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
