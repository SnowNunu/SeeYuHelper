//
//  SYProfileVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYProfileVM.h"
#import "SYAccountInfoEditVM.h"
#import "SYBaseInfoEditVM.h"
#import "SYStatisticsVM.h"
#import "SYSettingVM.h"
#import "SYFocusListVM.h"
#import "SYPresentListVM.h"
#import "SYMoneyManageVM.h"

@implementation SYProfileVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"我的";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self)
    self.requestUserBaseInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.requestUserBaseInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        @strongify(self)
        self.user = user;
        [self.services.client saveUser:user];
    }];
    [self.requestUserBaseInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.requestUserDetailInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_DETAIL_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUserDetail class]] sy_parsedResults];
    }];
    [self.requestUserDetailInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUserDetail *userDetail) {
        @strongify(self)
        self.userDetail = userDetail;
    }];
    [self.requestUserDetailInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterNextViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *kind) {
        if ([kind isEqual:@(0)]) {
            SYAccountInfoEditVM *vm = [[SYAccountInfoEditVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else if ([kind isEqual:@(1)]) {
            SYBaseInfoEditVM *vm = [[SYBaseInfoEditVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else if ([kind isEqual:@(2)]) {
            
        } else if ([kind isEqual:@(3)]) {
            SYStatisticsVM *vm = [[SYStatisticsVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else if ([kind isEqual:@(4)]){
           
        } else if ([kind isEqual:@(5)]) {
            SYSettingVM *vm = [[SYSettingVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
            
        } else if ([kind isEqual:@(6)]) {
            SYFocusListVM *vm = [[SYFocusListVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else if([kind isEqual:@(7)]){
            SYPresentListVM *vm = [[SYPresentListVM alloc] initWithServices:self.services params:@{SYViewModelUtilKey:@"receive"}];
            [self.services pushViewModel:vm animated:YES];
        } else if ([kind isEqual:@(8)]) {
            SYMoneyManageVM *vm = [[SYMoneyManageVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        }
        return [RACSignal empty];
    }];
}

@end
