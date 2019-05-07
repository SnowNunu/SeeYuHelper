//
//  SYUserListModel.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserListModel : SYObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *userHeadImg;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, assign) int userVipStatus;

@property (nonatomic, assign) int userDiamond;

@property (nonatomic, strong) NSString *userGender;

@property (nonatomic, assign) int followFlag;

@end

NS_ASSUME_NONNULL_END
