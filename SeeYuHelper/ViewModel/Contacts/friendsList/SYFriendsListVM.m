//
//  SYFriendsListVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendsListVM.h"
#import "SYNewFriendsVM.h"

@implementation SYFriendsListVM

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarHidden = YES;
    @weakify(self)
    self.getFriendsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FRIENDS_LIST parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYFriendsList class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [[[self.getFriendsListCommand.executionSignals switchToLatest] deliverOnMainThread] subscribeNext:^(SYFriendsList *friendsList) {
        self.freshFriendCount = [friendsList.freshFriendCount intValue];
        self.userFriendsArray = friendsList.userFriends;
    }];
    self.enterNewFriendsViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYNewFriendsVM *vm = [[SYNewFriendsVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
