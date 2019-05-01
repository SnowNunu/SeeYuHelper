//
//  SYNewFriendsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYNewFriendsVM.h"
#import "SYNewFriendModel.h"

@implementation SYNewFriendsVM

- (void)initialize {
    [super initialize];
    self.title = @"新的朋友";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self)
    self.requestNewFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
        @strongify(self)
        NSArray * (^mapAllFriends)(NSArray *) = ^(NSArray *friends) {
            return friends.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_NEW_FRIENDS_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYNewFriendModel class]] sy_parsedResults] map:mapAllFriends]takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestNewFriendsCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestNewFriendsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.agreeFriendRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *friendId) {
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"firendUserId":friendId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FRIEND_AGREE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYObject class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.agreeFriendRequestCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        [MBProgressHUD sy_showTips:@"同意申请好友成功"];
        // 成功的同时刷新一下列表
        self.datasource = [NSArray new];
        [self.requestNewFriendsCommand execute:nil];
    }];
    [self.agreeFriendRequestCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
