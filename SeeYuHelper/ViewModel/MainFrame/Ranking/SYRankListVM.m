//
//  SYRankListVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYRankListVM.h"
#import "SYFriendDetailInfoVM.h"

@implementation SYRankListVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.listType = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    self.requestRankListCommand = [[RACCommand alloc] initWithSignalBlock:^(id x) {
        @strongify(self)
        NSArray * (^mapAllRankList)(NSArray *) = ^(NSArray *rankList) {
            return rankList.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"topType":self.listType};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_RANKING_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYRankListModel class]] sy_parsedResults] map:mapAllRankList] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestRankListCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *list) {
        self.dataSource = list;
    }];
    [self.requestRankListCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterFriendDetailInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userId) {
        SYFriendDetailInfoVM *vm = [[SYFriendDetailInfoVM alloc] initWithServices:self.services params:@{SYViewModelIDKey:userId}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
