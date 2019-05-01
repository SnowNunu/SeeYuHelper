//
//  SYAnchorShowVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorShowVM.h"

@implementation SYAnchorShowVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.model = [SYAnchorsModel yy_modelWithJSON:params[SYViewModelUtilKey]];
    }
    return self;
}

- (void)initialize {
    self.prefersNavigationBarHidden = YES;
    self.interactivePopDisabled = YES;
    @weakify(self)
    self.goBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    self.requestFocusStateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        @strongify(self)
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_ANCHOR_FOCUS_STATE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYAnchorFocusStateModel class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestFocusStateCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYAnchorFocusStateModel *model) {
        if ([model.flag isEqualToString:@"1"]) {
            self.focus = YES;
        } else {
            self.focus = NO;
        }
    }];
    [self.requestFocusStateCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.focusAnchorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        @strongify(self)
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_ANCHOR_FOCUS_EXECUTE parameters:subscript.dictionary];
        return [[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYObject class]]  takeUntil:self.rac_willDeallocSignal];
    }];
    [self.focusAnchorCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        // 执行成功状态取反
        self.focus = !self.focus;
    }];
    [self.focusAnchorCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
