//
//  SYAuthenticationVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAuthenticationVM.h"
#import "SYRealnameVM.h"
#import "SYSelfieVM.h"

@implementation SYAuthenticationVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
//        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"个人认证";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestAuthenticationStateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IDENTITY_SATUS parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYAuthenticationModel class]] sy_parsedResults];
    }];
    [self.requestAuthenticationStateCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYAuthenticationModel *model) {
        self.authenticationModel = model;
    }];
    [self.requestAuthenticationStateCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterNextViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *kind) {
        if ([kind isEqual:@(0)]) {
            SYMobileBindingVM *vm = [[SYMobileBindingVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else if ([kind isEqual:@(1)]) {
            SYRealnameVM *vm = [[SYRealnameVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else {
            SYSelfieVM *vm = [[SYSelfieVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        }
        return [RACSignal empty];
    }];
}

@end
