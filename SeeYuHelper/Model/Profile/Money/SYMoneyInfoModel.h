//
//  SYMoneyInfoModel.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMoneyInfoModel : SYObject

@property (nonatomic, strong) NSArray *fundDetails;

@property (nonatomic, strong) NSArray *statistics;

@end

NS_ASSUME_NONNULL_END
