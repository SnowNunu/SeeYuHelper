//
//  SYMyMomentsVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYMyMomentsVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMyMomentsVC : SYVC <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SYMyMomentsVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
