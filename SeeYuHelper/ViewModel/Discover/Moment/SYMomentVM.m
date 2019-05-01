//
//  SYMomentVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentVM.h"
#import "SYMomentsModel.h"

@implementation SYMomentVM

- (void)initialize {
    self.pageSize = 10;
    @weakify(self)
    self.requestMomentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        NSArray * (^mapAllMoments)(NSArray *) = ^(NSArray *moments) {
            return moments.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"pageNum":page,@"pageSize":@(self.pageSize)};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MOMENTS_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYMomentsModel class]] sy_parsedResults] map:mapAllMoments] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestMomentsCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestMomentsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
