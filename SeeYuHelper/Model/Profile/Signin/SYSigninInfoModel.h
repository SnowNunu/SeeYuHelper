//
//  SYSigninInfoModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSigninInfoModel : SYObject

@property (nonatomic, strong) NSArray *awards;

@property (nonatomic, assign) int count;

@property (nonatomic, assign) int day;

@property (nonatomic, strong) NSDate *recentTime;

@end

NS_ASSUME_NONNULL_END
