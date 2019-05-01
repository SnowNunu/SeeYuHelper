//
//  SYFriendDetialModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"
#import "SYUser.h"
#import "SYMomentsModel.h"
#import "SYAuthenticationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFriendDetialModel : SYObject

@property (nonatomic, strong) SYUser *userBase;

@property (nonatomic, strong) NSArray<SYMomentsModel *> *userMoments;

@property (nonatomic, strong) SYAuthenticationModel *userAuth;

@end

NS_ASSUME_NONNULL_END
