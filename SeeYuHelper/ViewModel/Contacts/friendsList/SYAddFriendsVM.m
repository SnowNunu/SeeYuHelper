//
//  SYAddFriendsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAddFriendsVM.h"
#import "SYUser.h"

@implementation SYAddFriendsVM

- (void)initialize {
    [super initialize];
    self.title = @"添加好友";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self)
    self.searchFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *idOrAlias) {
        @strongify(self)
        NSArray * (^mapAllUsers)(NSArray *) = ^(NSArray *users) {
            return users.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"userName":idOrAlias};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FRIENDS_SEARCH parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] map:mapAllUsers]takeUntil:self.rac_willDeallocSignal];
    }];
    [self.searchFriendsCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.searchFriendsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.addFriendRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *friendId) {
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"firendUserId":friendId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FRIEND_ADD parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYObject class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.addFriendRequestCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        [MBProgressHUD sy_showTips:@"申请好友成功，请等待通过"];
    }];
    [self.addFriendRequestCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
