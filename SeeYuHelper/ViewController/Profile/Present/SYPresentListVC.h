//
//  SYPresentListVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYPresentListVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPresentListVC : SYVC

@property (nonatomic, strong) SYPresentListVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
