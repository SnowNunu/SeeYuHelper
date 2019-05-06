//
//  SYMoneyManageVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMoneyManageVC.h"
#import "SYMoneyInfoModel.h"

@interface SYMoneyManageVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *moneyBgView;

@property (nonatomic, strong) UILabel *totalMoneyTitleLabel;

@property (nonatomic, strong) UILabel *totalMoneyContentLabel;

@property (nonatomic, strong) UIButton *withdrawalBtn;

@property (nonatomic, strong) UIImageView *withdrawalImageView;

@property (nonatomic, strong) UILabel *withdrawalTitleLabel;

@property (nonatomic, strong) UILabel *withdrawalContentLabel;

@property (nonatomic, strong) UILabel *freezeMoneyTitleLabel;

@property (nonatomic, strong) UILabel *freezeMoneyContentLabel;

@property (nonatomic, strong) UILabel *progressTitleLabel;

@property (nonatomic, strong) UIImageView *totalProgressBgView;

@property (nonatomic, strong) UIImageView *currentProgressBgView;

@property (nonatomic, strong) UILabel *progressTimeLabel;

@property (nonatomic, strong) UILabel *progressStartLabel;

@property (nonatomic, strong) UILabel *progressMoneyLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *moreInfoBtn;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *incomeLabel;

@end

@implementation SYMoneyManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestMoneyManageInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, moneyInfo) subscribeNext:^(SYMoneyInfoModel *model) {
        @strongify(self)
        if (model != nil) {
            NSDictionary *params = model.fundDetails[0];
            self.totalMoneyContentLabel.text = [NSString stringWithFormat:@"%@元",params[@"balance"]];
            self.withdrawalContentLabel.text = [NSString stringWithFormat:@"%@元",params[@"availableWithdrawBalance"]];
            self.freezeMoneyContentLabel.text = [NSString stringWithFormat:@"%@元",params[@"lockBalance"]];
            self.progressTimeLabel.text = [NSString stringWithFormat:@"%@小时",params[@"baseDuration"]];
            self.progressMoneyLabel.text = [NSString stringWithFormat:@"%@元",params[@"basePay"]];
            [self.tableView reloadData];
        }
    }];
    [[self.withdrawalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.enterWithdrawalViewCommand execute:nil];
    }];
}

- (void)_setupSubViews {
    // 背景图片
    UIImageView *moneyBgView = [UIImageView new];
    moneyBgView.image = SYImageNamed(@"moneyManage_bg");
    moneyBgView.userInteractionEnabled = YES;
    _moneyBgView = moneyBgView;
    [self.view addSubview:moneyBgView];
    
    // 总金额
    UILabel *totalMoneyTitleLabel = [UILabel new];
    totalMoneyTitleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    totalMoneyTitleLabel.textColor = SYColor(255, 255, 255);
    totalMoneyTitleLabel.text = @"总金额";
    _totalMoneyTitleLabel = totalMoneyTitleLabel;
    [moneyBgView addSubview:totalMoneyTitleLabel];
    
    // 总金额数值
    UILabel *totalMoneyContentLabel = [UILabel new];
    totalMoneyContentLabel.font = SYRegularFont(17);
    totalMoneyContentLabel.textColor = SYColor(255, 255, 255);
    totalMoneyContentLabel.text = @"0元";
    _totalMoneyContentLabel = totalMoneyContentLabel;
    [moneyBgView addSubview:totalMoneyContentLabel];
    
    // 提现按钮
    UIButton *withdrawalBtn = [UIButton new];
    [withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    withdrawalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [withdrawalBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    _withdrawalBtn = withdrawalBtn;
    [moneyBgView addSubview:withdrawalBtn];
    
    // 提现图片
    UIImageView *withdrawalImageView = [UIImageView new];
    withdrawalImageView.image = SYImageNamed(@"detail_front");
    _withdrawalImageView = withdrawalImageView;
    [moneyBgView addSubview:withdrawalImageView];
    
    // 提现金额
    UILabel *withdrawalTitleLabel = [UILabel new];
    withdrawalTitleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    withdrawalTitleLabel.textColor = SYColor(255, 255, 255);
    withdrawalTitleLabel.text = @"提现金额";
    _withdrawalTitleLabel = withdrawalTitleLabel;
    [moneyBgView addSubview:withdrawalTitleLabel];
    
    // 提现金额数值
    UILabel *withdrawalContentLabel = [UILabel new];
    withdrawalContentLabel.font = SYRegularFont(17);
    withdrawalContentLabel.textColor = SYColor(255, 255, 255);
    withdrawalContentLabel.text = @"0元";
    _withdrawalContentLabel = withdrawalContentLabel;
    [moneyBgView addSubview:withdrawalContentLabel];
    
    // 冻结金额
    UILabel *freezeMoneyTitleLabel = [UILabel new];
    freezeMoneyTitleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    freezeMoneyTitleLabel.textColor = SYColor(255, 255, 255);
    freezeMoneyTitleLabel.text = @"冻结金额";
    _freezeMoneyTitleLabel = freezeMoneyTitleLabel;
    [moneyBgView addSubview:freezeMoneyTitleLabel];
    
    // 冻结金额数值
    UILabel *freezeMoneyContentLabel = [UILabel new];
    freezeMoneyContentLabel.font = SYRegularFont(17);
    freezeMoneyContentLabel.textColor = SYColor(255, 255, 255);
    freezeMoneyContentLabel.text = @"0元";
    _freezeMoneyContentLabel = freezeMoneyContentLabel;
    [moneyBgView addSubview:freezeMoneyContentLabel];
    
    // 工时进度
    UILabel *progressTitleLabel = [UILabel new];
    progressTitleLabel.textAlignment = NSTextAlignmentLeft;
    progressTitleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    progressTitleLabel.textColor = SYColor(255, 255, 255);
    progressTitleLabel.text = @"工时进度";
    _progressTitleLabel = progressTitleLabel;
    [moneyBgView addSubview:progressTitleLabel];
    
    // 总进度条
    UIImageView *totalProgressBgView = [UIImageView new];
    totalProgressBgView.backgroundColor = [UIColor whiteColor];
    _totalProgressBgView = totalProgressBgView;
    [moneyBgView addSubview:totalProgressBgView];
    
    // 当前进度条
    UIImageView *currentProgressBgView = [UIImageView new];
    currentProgressBgView.backgroundColor = [UIColor yellowColor];
    _currentProgressBgView = currentProgressBgView;
    [moneyBgView addSubview:currentProgressBgView];
    
    // 0进度点
    UILabel *progressStartLabel = [UILabel new];
    progressStartLabel.textAlignment = NSTextAlignmentLeft;
    progressStartLabel.font = SYRegularFont(13);
    progressStartLabel.textColor = SYColor(255, 255, 255);
    progressStartLabel.text = @"0";
    _progressStartLabel = progressStartLabel;
    [moneyBgView addSubview:progressStartLabel];
    
    // 总工作时长
    UILabel *progressTimeLabel = [UILabel new];
    progressTimeLabel.textAlignment = NSTextAlignmentRight;
    progressTimeLabel.font = SYRegularFont(13);
    progressTimeLabel.textColor = SYColor(255, 255, 255);
    progressTimeLabel.text = @"0小时";
    _progressTimeLabel = progressTimeLabel;
    [moneyBgView addSubview:progressTimeLabel];
    
    // 总薪水
    UILabel *progressMoneyLabel = [UILabel new];
    progressMoneyLabel.textAlignment = NSTextAlignmentRight;
    progressMoneyLabel.font = SYRegularFont(13);
    progressMoneyLabel.textColor = SYColor(255, 255, 255);
    progressMoneyLabel.text = @"0元";
    _progressMoneyLabel = progressMoneyLabel;
    [moneyBgView addSubview:progressMoneyLabel];
    
    // 每日详情
    UILabel *detailLabel = [UILabel new];
    detailLabel.font = [UIFont boldSystemFontOfSize:20.f];
    detailLabel.textColor = SYColor(51, 51, 51);
    detailLabel.text = @"每日详情";
    _detailLabel  = detailLabel;
    [self.view addSubview:detailLabel];
    
    // 更多数据
    UIButton *moreInfoBtn = [UIButton new];
    [moreInfoBtn setTitle:@"更多数据" forState:UIControlStateNormal];
    [moreInfoBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    moreInfoBtn.titleLabel.font = SYRegularFont(17);
    _moreInfoBtn = moreInfoBtn;
    [self.view addSubview:moreInfoBtn];
    
    // 日期
    UILabel *dateLabel = [UILabel new];
    dateLabel.font = SYRegularFont(17);
    dateLabel.textColor = SYColor(159, 105, 235);
    dateLabel.text = @"日期";
    dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel = dateLabel;
    [self.view addSubview:dateLabel];
    
    // 收入
    UILabel *incomeLabel = [UILabel new];
    incomeLabel.font = SYRegularFont(17);
    incomeLabel.textColor = SYColor(159, 105, 235);
    incomeLabel.text = @"收入（元）";
    incomeLabel.textAlignment = NSTextAlignmentRight;
    _incomeLabel = incomeLabel;
    [self.view addSubview:incomeLabel];
    
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
    [_moneyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.progressStartLabel).offset(15);
    }];
    [_totalMoneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.moneyBgView).offset(15);
        make.height.offset(20);
    }];
    [_totalMoneyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalMoneyTitleLabel);
        make.top.equalTo(self.totalMoneyTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.totalMoneyTitleLabel);
        make.right.equalTo(self.withdrawalImageView);
        make.width.offset(70);
    }];
    [_withdrawalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.totalMoneyTitleLabel);
        make.right.equalTo(self.moneyBgView).offset(-15);
        make.width.offset(9);
        make.height.offset(15);
    }];
    [_withdrawalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyBgView).offset(15);
        make.top.equalTo(self.totalMoneyContentLabel.mas_bottom).offset(30);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_withdrawalContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawalTitleLabel);
        make.top.equalTo(self.withdrawalTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_freezeMoneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.moneyBgView);
        make.top.equalTo(self.withdrawalTitleLabel);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_freezeMoneyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.freezeMoneyTitleLabel);
        make.top.equalTo(self.freezeMoneyTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_progressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyBgView).offset(15);
        make.top.equalTo(self.freezeMoneyContentLabel.mas_bottom).offset(15);
        make.height.offset(15);
    }];
    [_totalProgressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyBgView).offset(15);
        make.right.equalTo(self.moneyBgView).offset(-15);
        make.height.offset(3);
        make.top.equalTo(self.progressTitleLabel.mas_bottom).offset(15);
    }];
    [_currentProgressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self.totalProgressBgView);
        make.width.offset(50);
    }];
    [_progressStartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalProgressBgView.mas_bottom).offset(4);
        make.left.equalTo(self.moneyBgView).offset(15);
        make.height.offset(10);
    }];
    [_progressTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.totalProgressBgView.mas_top).offset(-4);
        make.height.offset(10);
        make.right.equalTo(self.totalProgressBgView);
    }];
    [_progressMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalProgressBgView.mas_bottom).offset(4);
        make.height.offset(10);
        make.right.equalTo(self.totalProgressBgView);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyBgView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(30);
        make.height.offset(20);
    }];
    [_moreInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyBgView.mas_bottom).offset(60);
        make.right.equalTo(self.view).offset(-30);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(60);
        make.width.offset(95);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(30);
        make.height.offset(15);
    }];
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-60);
        make.top.height.equalTo(self.dateLabel);
        make.width.offset(90);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(30);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.moneyInfo.statistics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = self.viewModel.moneyInfo.statistics[indexPath.row];
    
    UILabel *dateContentLabel = [UILabel new];
    dateContentLabel.text = params[@"datetime"];
    dateContentLabel.textAlignment = NSTextAlignmentLeft;
    dateContentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:dateContentLabel];
    
    UILabel *incomeContentLabel = [UILabel new];
    incomeContentLabel.text = [NSString stringWithFormat:@"%@",params[@"money"]];
    incomeContentLabel.textAlignment = NSTextAlignmentCenter;
    incomeContentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:incomeContentLabel];
    
    [dateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(60);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
        make.width.offset(95);
    }];
    [incomeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-60);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
        make.width.offset(90);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
