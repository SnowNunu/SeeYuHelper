//
//  SYFriendsListVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYFriendsList.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFriendsListVM : SYVM

@property(nonatomic, assign) int freshFriendCount;

@property(nonatomic, strong) NSArray *userFriendsArray;

@property(nonatomic, strong) RACCommand *getFriendsListCommand;

@property(nonatomic, strong) RACCommand *enterNewFriendsViewCommand;

@end

NS_ASSUME_NONNULL_END
