//
//  SYAnchorRandomCellModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/21.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorRandomCellModel : SYObject

/* 主播id */
@property (nonatomic, strong) NSString *userId;

/* 主播爱好 */
@property (nonatomic, strong) NSString *userSpecialty;

/* 主播语聊价格 */
@property (nonatomic, strong) NSString *anchorChatCost;

/* 主播展示视频 */
@property (nonatomic, strong) NSString *showVideo;

@end

NS_ASSUME_NONNULL_END
