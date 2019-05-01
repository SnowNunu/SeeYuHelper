//
//  SYFriendsList.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/14.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFriendsList : SYObject

@property (nonatomic, strong) NSMutableArray *userFriends;

@property (nonatomic, strong) NSString *freshFriendCount;

@end

NS_ASSUME_NONNULL_END
