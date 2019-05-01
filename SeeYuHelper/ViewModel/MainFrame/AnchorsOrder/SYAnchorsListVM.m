//
//  SYAnchorsListVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsListVM.h"
#import "SYAnchorsModel.h"

@implementation SYAnchorsListVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.anchorType = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    self.requestAnchorsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSArray * (^mapAllAnchors)(NSArray *) = ^(NSArray *anchors) {
            return anchors.rac_sequence.array;
        };
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"type":self.anchorType};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_ANCHOR_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYAnchorsModel class]] sy_parsedResults] map:mapAllAnchors] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [self.requestAnchorsListCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.anchorsArray = array;
    }];
    [self.requestAnchorsListCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    
    self.enterAnchorShowViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYAnchorShowVM *showVM = [[SYAnchorShowVM alloc] initWithServices:self.services params:params];
        [self.services pushViewModel:showVM animated:YES];
        return [RACSignal empty];
    }];
}

@end
