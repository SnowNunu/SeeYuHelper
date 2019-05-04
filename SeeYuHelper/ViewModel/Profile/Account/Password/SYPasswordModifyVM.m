//
//  SYPasswordModifyVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPasswordModifyVM.h"

@implementation SYPasswordModifyVM

- (void)initialize {
    [super initialize];
    self.title = @"修改密码";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.updatePasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PASSWORD_UPDATE parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYObject class]] sy_parsedResults];
    }];
    [self.updatePasswordCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        [MBProgressHUD sy_showTips:@"密码已经修改成功！"];
    }];
    [self.updatePasswordCommand.errors subscribeNext:^(NSError *error) {
        if ([error code] == 15) {
            [MBProgressHUD sy_showError:@"原密码不正确，请检查！"];
        } else if([error code] == 16) {
            [MBProgressHUD sy_showError:@"当前账户已被封禁，请联系客服！"];
        } else {
            [MBProgressHUD sy_showErrorTips:error];
        }
    }];
}

@end
