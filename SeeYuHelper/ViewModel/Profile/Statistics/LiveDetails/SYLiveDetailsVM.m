//
//  SYLiveDetailsVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLiveDetailsVM.h"

@implementation SYLiveDetailsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"直播详情";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.reuqestLiveDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_LIVE_DETAIL_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYLiveDetailModel class]] sy_parsedResults];
    }];
    [self.reuqestLiveDetailCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYLiveDetailModel *liveDetail) {
        self.datasource = liveDetail.videoStatisticsDetails;
    }];
    [self.reuqestLiveDetailCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
