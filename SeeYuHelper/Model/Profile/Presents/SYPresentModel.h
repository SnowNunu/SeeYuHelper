//
//  SYPresentModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPresentModel : SYObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *giftName;

@property (nonatomic, strong) NSString *giveGiftNumber;

@property (nonatomic, strong) NSString *userDiamond;

@property (nonatomic, strong) NSString *giftImg;

@property (nonatomic, strong) NSString *giveDate;

@property (nonatomic, strong) NSString *giveDateWeek;

@end

NS_ASSUME_NONNULL_END
