//
//  SYAddFriendsVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAddFriendsVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *searchFriendsCommand;

@property (nonatomic, strong) RACCommand *addFriendRequestCommand;

@end

NS_ASSUME_NONNULL_END
