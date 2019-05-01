//
//  SYOutboundModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYOutboundModel : SYObject

/* 外呼用户昵称 */
@property (nonatomic, strong) NSString *alias;

/* 外呼用户头像 */
@property (nonatomic, strong) NSString *avatarImage;

/* 展示视频 */
@property (nonatomic, strong) NSString *videoShow;

/* 自动挂断时长 */
@property (nonatomic, strong) NSString *interval;

@end

NS_ASSUME_NONNULL_END
