//
//  SYGiftPackageVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYGiftPackageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftPackageVM : SYVM

@property (nonatomic, strong) NSArray *giftPackagesArray;

@property (nonatomic, strong) RACCommand *receiveGiftCommand;

@end

NS_ASSUME_NONNULL_END
