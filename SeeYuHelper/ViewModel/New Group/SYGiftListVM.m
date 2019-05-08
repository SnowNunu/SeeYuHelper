//
//  SYGiftListVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/8.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftListVM.h"

@implementation SYGiftListVM

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarHidden = YES;
    @weakify(self)
    self.requestGiftListInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllListModel)(NSArray *) = ^(NSArray *listModel) {
            return listModel.rac_sequence.array;
        };
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_ANCHOR_GIFT_LIST_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[[self.services.client enqueueRequest:request resultClass:[SYGiftListModel class]] sy_parsedResults] map:mapAllListModel];
    }];
    [self.requestGiftListInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestGiftListInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
