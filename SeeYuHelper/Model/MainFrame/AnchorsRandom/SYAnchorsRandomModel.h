//
//  SYAnchorsRandomModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/21.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"
#import "SYAnchorRandomCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsRandomModel : SYObject

/* 在线主播的数量 */
@property (nonatomic, assign) int anchorsLenth;

@property (nonatomic, strong) NSArray<SYAnchorRandomCellModel *> *anchors;

@end

NS_ASSUME_NONNULL_END
