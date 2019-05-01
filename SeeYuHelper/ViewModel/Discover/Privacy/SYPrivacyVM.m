//
//  SYPrivacyVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyVM.h"
#import "SYPrivacyShowVM.h"

@implementation SYPrivacyVM

- (void)initialize {
    @weakify(self)
    self.requestPrivacyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllPrivacy)(NSArray *) = ^(NSArray *privacy) {
            return privacy.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PRIVACY_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYPrivacyModel class]] sy_parsedResults] map:mapAllPrivacy] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestPrivacyCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestPrivacyCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterPrivacyShowViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYPrivacyShowVM *vm = [[SYPrivacyShowVM alloc] initWithServices:self.services params:params];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
