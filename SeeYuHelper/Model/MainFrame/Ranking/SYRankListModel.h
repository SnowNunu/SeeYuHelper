//
//  SYRankListModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/21.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRankListModel : SYObject

/* 用户id */
@property (nonatomic, strong) NSString *userId;

/* 用户昵称 */
@property (nonatomic, strong) NSString *userName;

/* 用户头像 */
@property (nonatomic, strong) NSString *userHeadImg;

/* 用户权重值 */
@property (nonatomic, strong) NSString *score;

@end

NS_ASSUME_NONNULL_END
