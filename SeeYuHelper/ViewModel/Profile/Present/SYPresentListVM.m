//
//  SYPresentListVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPresentListVM.h"

@implementation SYPresentListVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.presentsType = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    self.requestPresentsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSArray * (^mapAllPresents)(NSArray *) = ^(NSArray *presents) {
            return presents.rac_sequence.array;
        };
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"type":self.presentsType};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PRESENTS_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYPresentModel class]] sy_parsedResults] map:mapAllPresents] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestPresentsListCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.presentsArray = array;
    }];
    [self.requestPresentsListCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
