//
//  SYMobileBindingVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMobileBindingVM.h"

@implementation SYMobileBindingVM

- (void)initialize {
    [super initialize];
    self.title = @"手机认证";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.getAuthCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *parameters) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_AUTH_CODE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    self.bindCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *parameters) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MOBILE_BIND parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
