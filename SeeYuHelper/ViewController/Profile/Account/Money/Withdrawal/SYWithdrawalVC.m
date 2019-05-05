//
//  SYWithdrawalVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYWithdrawalVC.h"
#import "SYWithdrawalModel.h"

@interface SYWithdrawalVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *moneyNumberLabel;

@property (nonatomic, strong) UILabel *yuanLabel;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"支付宝提现",@"image":@"icon_list_alipay"},@{@"label":@"银行卡提现",@"image":@"icon_list_cardPay"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestWithdrawalMoneyInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, model) subscribeNext:^(SYWithdrawalModel *model) {
        if (model != nil) {
            self.moneyNumberLabel.text = [NSString stringWithFormat:@"%d",model.availableWithdraw];
        }
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.separatorInset = UIEdgeInsetsZero;
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 135)];
    headerImageView.image = SYImageNamed(@"withdrawal_bg");
    _headerImageView = headerImageView;
    tableView.tableHeaderView = headerImageView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.font = SYRegularFont(16);
    moneyLabel.text = @"可提现金额";
    _moneyLabel = moneyLabel;
    [headerImageView addSubview:moneyLabel];
    
    UILabel *moneyNumberLabel = [UILabel new];
    moneyNumberLabel.textColor = [UIColor whiteColor];
    moneyNumberLabel.textAlignment = NSTextAlignmentCenter;
    moneyNumberLabel.font = [UIFont boldSystemFontOfSize:60];
    moneyNumberLabel.text = @"0";
    _moneyNumberLabel = moneyNumberLabel;
    [headerImageView addSubview:moneyNumberLabel];
    
    UILabel *yuanLabel = [UILabel new];
    yuanLabel.textColor = [UIColor whiteColor];
    yuanLabel.textAlignment = NSTextAlignmentCenter;
    yuanLabel.font = [UIFont boldSystemFontOfSize:20];
    yuanLabel.text = @"元";
    _yuanLabel = yuanLabel;
    [headerImageView addSubview:yuanLabel];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView).offset(15);
        make.top.equalTo(self.headerImageView).offset(30);
        make.height.offset(20);
    }];
    [_moneyNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerImageView);
        make.height.offset(45);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(15);
    }];
    [_yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.moneyNumberLabel);
        make.left.equalTo(self.moneyNumberLabel.mas_right).offset(5);
        make.height.offset(20);
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
    
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.image = SYImageNamed(params[@"image"]);
    [cell.contentView addSubview:logoImageView];
    
    UILabel *payWayLabel = [UILabel new];
    payWayLabel.textAlignment = NSTextAlignmentLeft;
    payWayLabel.textColor = SYColor(51, 51, 51);
    payWayLabel.text = params[@"label"];
    payWayLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:payWayLabel];
    
    UIImageView *arrowImageView = [UIImageView new];
    arrowImageView.image = SYImageNamed(@"detail_back");
    [cell.contentView addSubview:arrowImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
    }];
    [payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
        make.left.equalTo(logoImageView.mas_right).offset(15);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.height.offset(14);
        make.width.offset(7);
        make.centerY.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.viewModel.enterAlipayWithdrawalViewCommand execute:nil];
    } else {
        [self.viewModel.enterUnionWithdrawalViewCommand execute:nil];
    }
}

@end
