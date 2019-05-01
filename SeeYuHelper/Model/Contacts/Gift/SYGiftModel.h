//
//  SYGiftModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftModel : SYObject

@property (nonatomic, assign) int Diamonds;

@property (nonatomic, strong) NSArray *gifts;

@end

NS_ASSUME_NONNULL_END
