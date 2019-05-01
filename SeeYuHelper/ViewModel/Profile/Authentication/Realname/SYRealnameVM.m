//
//  SYRealnameVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYRealnameVM.h"

@implementation SYRealnameVM

- (void)initialize {
    [super initialize];
    self.title = @"身份认证";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.uploadRealnameAuthticationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *parameters) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IDENTITY_UPLOAD parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
