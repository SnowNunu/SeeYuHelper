//
//  SYCoverInfoEditVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYCoverInfoEditVM.h"

@implementation SYCoverInfoEditVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if(self = [super initWithServices:services params:params]) {
        self.type = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    @weakify(self)
    if ([self.type isEqualToString:@"modify"]) {
        self.title = @"编辑封面";
    } else {
        self.title = @"资料完善";
    }
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestUserShowInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_COVER_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUserInfoEditModel class]] sy_parsedResults];
    }];
    [self.requestUserShowInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUserInfoEditModel *model) {
        self.model = model;
    }];
    [self.requestUserShowInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.uploadUserCoverCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *data) {
        @strongify(self)
        [MBProgressHUD sy_showProgressHUD:@"封面上传中,请稍候"];
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_SHOW_UPLOAD parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueUploadRequest:request resultClass:[SYUserInfoEditModel class] fileDatas:@[data] namesArray:@[@"showImage-jpg"] mimeType:@"image/png"] sy_parsedResults];
    }];
    [self.uploadUserCoverCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUserInfoEditModel *model) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showTips:@"上传成功"];
        self.model = model;
        if (![self.type isEqualToString:@"modify"]) {
            [self.enterModifyVideoViewCommand execute:nil];
        }
    }];
    [self.uploadUserCoverCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterModifyVideoViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYVideoInfoEditVM *vm = [[SYVideoInfoEditVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
