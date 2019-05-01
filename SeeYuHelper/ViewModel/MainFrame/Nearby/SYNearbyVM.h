//
//  SYNearbyVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYTableVM.h"
#import "SYVM.h"
#import "SYFriendDetailInfoVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYNearbyVM : SYVM

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *nearbyFriends;

/// 当前页
@property (nonatomic, readwrite, assign) NSUInteger pageNum;

/// 每页的数据
@property (nonatomic, readwrite, assign) NSUInteger pageSize;

@property (nonatomic, strong) RACCommand *requestNearbyFriendsCommand;

@property (nonatomic, strong) RACCommand *enterFriendDetailCommand;

@end

NS_ASSUME_NONNULL_END
