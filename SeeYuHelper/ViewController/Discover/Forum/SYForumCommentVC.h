//
//  SYForumCommentVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYForumCommentVM.h"
#import "SYForumCommentCell.h"
#import "SYForumCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumCommentVC : SYVC

@property (nonatomic, strong) SYForumCommentVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
