//
//  SYAnchorsListVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAnchorShowVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsListVM : SYVM

// 主播类型
@property (nonatomic, strong) NSString *anchorType;

// 主播列表
@property (nonatomic, strong) NSArray *anchorsArray;

// 获取主播列表
@property (nonatomic, strong) RACCommand *requestAnchorsListCommand;

// 进入主播详情展示
@property (nonatomic, strong) RACCommand *enterAnchorShowViewCommand;

@end

NS_ASSUME_NONNULL_END
