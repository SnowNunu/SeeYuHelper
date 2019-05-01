//
//  SYLoginVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLoginVM.h"
#import "SYRegisterVM.h"

@implementation SYLoginVM

- (void)initialize {
    [super initialize];
    self.title = @"登录";
    self.backTitle = @"";
    // 隐藏导航栏下细线
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self);
    self.enterRegisterViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYRegisterVM *viewModel = [[SYRegisterVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.getAuthCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *parameters) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_AUTH_CODE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *parameters) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_AUTH_LOGIN parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
