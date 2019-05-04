//
//  SYFocusListVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFocusListVM.h"
#import "SYFocusModel.h"

@implementation SYFocusListVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"关注列表";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestFocusListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSArray * (^mapAllFocuss)(NSArray *) = ^(NSArray *focus) {
            return focus.rac_sequence.array;
        };
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:@{@"userId":self.services.client.currentUserId}];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTP_PATH_USER_FOLLOW_LIST parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[[self.services.client enqueueRequest:request resultClass:[SYFocusModel class]] sy_parsedResults] map:mapAllFocuss];
    }];
    [self.requestFocusListCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestFocusListCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
