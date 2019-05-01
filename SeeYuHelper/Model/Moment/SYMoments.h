//
//  SYMoments.h
//  SYDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  微信朋友圈数据模型

#import "SYObject.h"
#import "SYMoment.h"

@interface SYMoments : SYObject

/// 多条动态
@property (nonatomic, strong) NSArray <SYMoment *> *moments;

@end
