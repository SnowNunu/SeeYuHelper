//
//  SYLoginVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLoginVM.h"

@implementation SYLoginVM

- (void)initialize {
    [super initialize];
    self.title = @"登录";
    self.prefersNavigationBarHidden = YES;
    @weakify(self);
    self.enterInfoSupplementViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYInfoSupplementVM *viewModel = [[SYInfoSupplementVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    self.enterHomePageViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 存储登录账号
            [SAMKeychain setRawLogin:self.services.client.currentUserId];
            // 发送通知进行页面跳转
            [SYNotificationCenter postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogin)}];
            [MBProgressHUD sy_showProgressHUD:@"欢迎使用"];
        });
        return [RACSignal empty];
    }];
    self.requestUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.requestUserInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services.client saveUser:user];
            // 存储登录账号
            [SAMKeychain setRawLogin:self.services.client.currentUserId];
            // 发送通知进行页面跳转
            [SYNotificationCenter postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogin)}];
            [MBProgressHUD sy_showProgressHUD:@"欢迎使用"];
        });
    }];
    [self.requestUserInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
