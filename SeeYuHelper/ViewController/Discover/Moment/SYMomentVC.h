//
//  SYMomentVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYMomentVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMomentVC : SYVC

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SYMomentVM *viewModel;

@end

NS_ASSUME_NONNULL_END
