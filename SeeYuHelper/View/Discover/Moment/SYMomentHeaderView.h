//
//  SYMomentHeaderView.h
//  SeeYu
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  动态正文 view

#import <UIKit/UIKit.h>
#import "SYReactiveView.h"

@interface SYMomentHeaderView : UITableViewHeaderFooterView<SYReactiveView>

/// 段
@property (nonatomic, readwrite, assign) NSInteger section;

/// generate a header
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;


@end
