//
//  SYRankListVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYRankListVM.h"
#import "SYTableView.h"
#import "UIScrollView+SYRefresh.h"
#import "SYRankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRankListVC : SYVC <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SYTableView *tableView;

@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
