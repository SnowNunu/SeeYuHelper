//
//  SYNewFriendModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYNewFriendModel : SYObject

// 新的好友ID
@property (nonatomic, strong) NSString *userFriendId;

// 新的好友昵称
@property (nonatomic, strong) NSString *userFriendName;

// 新的好友头像
@property (nonatomic, strong) NSString *userHeadImg;

// 新的好友关系
@property (nonatomic, strong) NSString *relation_status;

@end

NS_ASSUME_NONNULL_END
