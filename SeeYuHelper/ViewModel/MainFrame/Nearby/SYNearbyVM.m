//
//  SYNearbyVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYNearbyVM.h"

@implementation SYNearbyVM

- (void)initialize {
    self.pageSize = 10; // 每次加载10页
    self.pageNum = 1;   // 默认从第一页开始加载
    @weakify(self)
    self.requestNearbyFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    RAC(self,nearbyFriends) = self.requestNearbyFriendsCommand.executionSignals.switchToLatest;
    RAC(self,dataSource) = [RACObserve(self, nearbyFriends) map:^(NSArray * nearbyFriends) {
        @strongify(self)
        return [self dataSourceWithNearbyFriends:nearbyFriends];
    }];
    self.enterFriendDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userId) {
        SYFriendDetailInfoVM *vm = [[SYFriendDetailInfoVM alloc] initWithServices:self.services params:@{SYViewModelIDKey:userId}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapNearbyFriends)(NSArray *) = ^(NSArray *friends) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            friends = @[(self.nearbyFriends ?: @[]).rac_sequence, friends.rac_sequence].rac_sequence.flatten.array;
        }
        return friends;
    };
    
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_NEARBY parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults] map:mapNearbyFriends];
}

#pragma mark - 辅助方法
- (NSArray *)dataSourceWithNearbyFriends:(NSArray *)nearbyFriends {
    if (SYObjectIsNil(nearbyFriends) || nearbyFriends.count == 0) return nil;
    NSArray *datasources = [nearbyFriends.rac_sequence map:^(SYUser *user) {
        return user;
    }].array;
    return datasources ?: @[] ;
}

@end
