//
//  SYFriendModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFriendModel : SYObject

@property (nonatomic, strong) NSString *userFriendId;

@property (nonatomic, strong) NSString *userFriendName;

@property (nonatomic, strong) NSString *userHeadImg;

@end

NS_ASSUME_NONNULL_END
