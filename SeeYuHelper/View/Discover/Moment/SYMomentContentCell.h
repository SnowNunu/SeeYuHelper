//
//  SYMomentContentCell.h
//  SYDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  评论、点赞基类

#import <UIKit/UIKit.h>
#import "SYReactiveView.h"
//#import "SYMomentContentItemViewModel.h"


@interface SYMomentContentCell : UITableViewCell<SYReactiveView>

/// 正文
@property (nonatomic, readonly, weak) YYLabel *contentLable;
/// divider
@property (nonatomic, readwrite, weak) UIImageView *divider;
/// viewModel
//@property (nonatomic , readonly , strong) SYMomentContentItemViewModel *viewModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
