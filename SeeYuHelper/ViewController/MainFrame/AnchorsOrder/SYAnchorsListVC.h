//
//  SYAnchorsListVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYAnchorsListVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsListVC : SYVC

@property (nonatomic, strong) SYAnchorsListVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
