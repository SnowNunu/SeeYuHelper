//
//  SYLoginVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYInfoSupplementVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLoginVM : SYVM

// 进入注册页面
@property (nonatomic, strong) RACCommand *enterInfoSupplementViewCommand;

// 进入主页界面
@property (nonatomic, strong) RACCommand *enterHomePageViewCommand;

@end

NS_ASSUME_NONNULL_END
