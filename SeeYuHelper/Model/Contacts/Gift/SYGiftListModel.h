//
//  SYGiftListModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftListModel : SYObject

@property (nonatomic, strong) NSString *giftName;

@property (nonatomic, strong) NSString *giftImg;

@property (nonatomic, assign) int totalNum;

@end

NS_ASSUME_NONNULL_END
