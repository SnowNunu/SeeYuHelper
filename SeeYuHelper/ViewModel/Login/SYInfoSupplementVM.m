//
//  SYInfoSupplementVM.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/2.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYInfoSupplementVM.h"

@implementation SYInfoSupplementVM

- (void)initialize {
    [super initialize];
    self.title = @"资料完善";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self)
    self.requestUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.requestUserInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        self.user = user;
        [self.services.client saveUser:user];
    }];
    [self.requestUserInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterHobbyChooseViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYHobbyVM *vm = [[SYHobbyVM alloc] initWithServices:self.services params:nil];
        vm.hobbyBlock = ^(NSString * _Nonnull hobby) {
            [self.updateUserInfoCommand execute:@{@"userId":self.user.userId,@"userSpecialty":hobby}];
        };
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterUploadCoverViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYCoverInfoEditVM *vm = [[SYCoverInfoEditVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.uploadAvatarImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *data) {
        @strongify(self)
        [MBProgressHUD sy_showProgressHUD:@"头像上传中,请稍候"];
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_HEAD_UPLOAD parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueUploadRequest:request resultClass:[SYUser class] fileDatas:@[data] namesArray:@[@"headImage-jpg"] mimeType:@"image/png"] sy_parsedResults];
    }];
    [self.uploadAvatarImageCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showTips:@"头像上传成功"];
        self.user = user;
        [self.services.client saveUser:user];
    }];
    [self.uploadAvatarImageCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.updateUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_UPDATE parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.updateUserInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        self.user = user;
        [self.services.client saveUser:user];
    }];
    [self.updateUserInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
