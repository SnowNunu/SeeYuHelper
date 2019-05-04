//
//  SYAccountInfoEditVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAccountInfoEditVC.h"

@interface SYAccountInfoEditVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYAccountInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"修改密码",@"kind":@"text"},@{@"label":@"资金管理",@"kind":@"text"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
//    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
//        if (user != nil) {
//            [self.tableView reloadData];
//        }
//    }];
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
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *params = _dataSource[indexPath.row];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = SYColor(51, 51, 51);
    titleLabel.font = SYRegularFont(16);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = params[@"label"];
    [cell.contentView addSubview:titleLabel];
    
    UIImageView *arrowImageView = [UIImageView new];
    arrowImageView.image = SYImageNamed(@"detail_back");
    [cell.contentView addSubview:arrowImageView];
    if ([params[@"kind"] isEqualToString:@"label"]) {
        arrowImageView.hidden = YES;
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.width.offset(70);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(7);
        make.height.offset(14);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.viewModel.enterPasswordModifyViewCommand execute:nil];
    } else {
        
    }
}

@end
