//
//  SYAnchorsRandomVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsRandomVM.h"

@implementation SYAnchorsRandomVM

- (void)initialize {
    @weakify(self)
    self.requestOnlineAnchorsList = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_ANCHOR_ONLINE_LIST parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYAnchorsRandomModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestOnlineAnchorsList.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYAnchorsRandomModel *model) {
        @strongify(self)
        self.onlineNumber = model.anchorsLenth;
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *dict in model.anchors) {
            SYAnchorRandomCellModel *cell = [SYAnchorRandomCellModel mj_objectWithKeyValues:dict];
            [temp addObject:cell];
        }
        self.datasource = [temp mutableCopy];
    }];
    [self.requestOnlineAnchorsList.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
