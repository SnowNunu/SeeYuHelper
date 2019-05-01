//
//  SYAuthenticationVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAuthenticationVC.h"

@interface SYAuthenticationVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@"绑定手机",@"实名认证",@"自拍认证"];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestAuthenticationStateCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, authenticationModel) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = SYColor(51, 51, 51);
    titleLabel.font = SYRegularFont(16);
    titleLabel.text = _dataSource[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *stateLabel = [UILabel new];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = SYRegularFont(12);
    [cell.contentView addSubview:stateLabel];
    if (indexPath.row == 0) {
        if (self.viewModel.authenticationModel != nil) {
            if (self.viewModel.authenticationModel.mobileFlag == 0) {
                stateLabel.textColor = SYColor(153, 153, 153);
                stateLabel.text = @"未绑定";
            } else {
                stateLabel.textColor = SYColor(159, 105, 235);
                stateLabel.text = @"已绑定";
            }
        }
    } else if (indexPath.row == 1) {
        if (self.viewModel.authenticationModel != nil) {
            if (self.viewModel.authenticationModel.identityFlag == 0) {
                stateLabel.textColor = SYColor(153, 153, 153);
                stateLabel.text = @"未认证";
            } else if (self.viewModel.authenticationModel.identityFlag == 1){
                stateLabel.textColor = SYColor(159, 105, 235);
                stateLabel.text = @"认证中";
            } else if (self.viewModel.authenticationModel.identityFlag == 2){
                stateLabel.textColor = SYColor(159, 105, 235);
                stateLabel.text = @"认证失败";
            } else {
                stateLabel.textColor = SYColor(159, 105, 235);
                stateLabel.text = @"已认证";
            }
        }
    } else {
        if (self.viewModel.authenticationModel != nil) {
            if (self.viewModel.authenticationModel != nil) {
                if (self.viewModel.authenticationModel.selfieFlag == 0) {
                    stateLabel.textColor = SYColor(153, 153, 153);
                    stateLabel.text = @"未认证";
                } else if (self.viewModel.authenticationModel.selfieFlag == 1){
                    stateLabel.textColor = SYColor(159, 105, 235);
                    stateLabel.text = @"认证中";
                } else if (self.viewModel.authenticationModel.selfieFlag == 2){
                    stateLabel.textColor = SYColor(159, 105, 235);
                    stateLabel.text = @"认证失败";
                } else {
                    stateLabel.textColor = SYColor(159, 105, 235);
                    stateLabel.text = @"已认证";
                }
            }
        }
    }
    
    UIImageView *arrowImageView = [UIImageView new];
    arrowImageView.image = SYImageNamed(@"detail_back");
    [cell.contentView addSubview:arrowImageView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-15);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(7);
        make.height.offset(14);
        make.centerY.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        if (self.viewModel.authenticationModel.mobileFlag == 0) {
            [self.viewModel.enterNextViewCommand execute:@(0)];
        }
    } else if (indexPath.row == 1) {
        if (self.viewModel.authenticationModel.identityFlag == 0 || self.viewModel.authenticationModel.identityFlag == 2) {
            [self.viewModel.enterNextViewCommand execute:@(1)];
        }
    } else {
        if (self.viewModel.authenticationModel.selfieFlag == 0 || self.viewModel.authenticationModel.selfieFlag == 2) {
            [self.viewModel.enterNextViewCommand execute:@(2)];
        }
    }
}

@end
