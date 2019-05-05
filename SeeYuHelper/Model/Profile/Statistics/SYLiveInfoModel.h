//
//  SYLiveInfoModel.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveInfoModel : SYObject

@property (nonatomic, assign) int totalDuration;

@property (nonatomic, assign) int baseDuration;

@property (nonatomic, assign) int callDuration;

@property (nonatomic, assign) int answerDuration;

@property (nonatomic, strong) NSArray *videoDurationDay;

@end

NS_ASSUME_NONNULL_END
