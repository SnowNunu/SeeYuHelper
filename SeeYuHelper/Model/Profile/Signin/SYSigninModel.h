//
//  SYSigninModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSigninModel : SYObject

@property (nonatomic, strong) NSString *signId;

@property (nonatomic, strong) NSString *signDay;

@property (nonatomic, strong) NSString *signNum;

@property (nonatomic, strong) NSString *signType;

@property (nonatomic, strong) NSString *signDate;

@property (nonatomic, strong) NSString *signGiftid;

@property (nonatomic, strong) NSString *signGiftPrice;

@property (nonatomic, strong) NSString *signGiftName;

@property (nonatomic, strong) NSString *signGiftUrl;

@end

NS_ASSUME_NONNULL_END
