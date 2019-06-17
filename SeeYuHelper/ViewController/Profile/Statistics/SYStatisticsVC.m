//
//  SYStatisticsVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYStatisticsVC.h"

@interface SYStatisticsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"礼物数据统计",@"kind":@"arrow"}];
//    _dataSource = @[@{@"label":@"直播数据统计",@"kind":@"arrow"},@{@"label":@"礼物数据统计",@"kind":@"arrow"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.separatorInset = UIEdgeInsetsZero;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = _dataSource[indexPath.row];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = params[@"label"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:contentLabel];
    
    UIButton *arrowBtn = [UIButton new];
    [arrowBtn setImage:SYImageNamed(@"tableview_arrow") forState:UIControlStateNormal];
    [cell.contentView addSubview:arrowBtn];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.width.offset(100);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
    }];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.centerY.equalTo(cell.contentView);
        make.width.offset(7);
        make.height.offset(14);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.row == 0) {
//        [self.viewModel.enterLiveStatisticsViewCommand execute:nil];
//    } else {
    [self.viewModel.enterPresentListViewCommand execute:nil];
//    }
}

@end
