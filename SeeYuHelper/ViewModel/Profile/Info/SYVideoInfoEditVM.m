//
//  SYVideoInfoEditVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVideoInfoEditVM.h"

@implementation SYVideoInfoEditVM

- (void)initialize {
    [super initialize];
    @weakify(self)
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
    self.uploadUserVideoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *data) {
        @strongify(self)
        [MBProgressHUD sy_showProgressHUD:@"视频上传中,请稍候"];
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_SHOW_UPLOAD parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueUploadRequest:request resultClass:[SYUserInfoEditModel class] fileDatas:@[data] namesArray:@[@"showImage-mp4"] mimeType:@"video/mpeg4"] sy_parsedResults];
    }];
    [self.uploadUserVideoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUserInfoEditModel *model) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showTips:@"上传成功，请等待审核"];
        self.model = model;
    }];
    [self.uploadUserVideoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUD];
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
