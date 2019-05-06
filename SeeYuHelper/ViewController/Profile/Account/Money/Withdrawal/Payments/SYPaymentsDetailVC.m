//
//  SYPaymentsDetailVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPaymentsDetailVC.h"

@interface SYPaymentsDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *dateLabel;

@property (nonatomic ,strong) UILabel *incomeLabel;

@property (nonatomic ,strong) UILabel *stateLabel;

@end

@implementation SYPaymentsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestPaymentsDetailCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, model) subscribeNext:^(SYPaymentsModel *model) {
        if (model != nil) {
            [self.tableView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UILabel *dateLabel = [UILabel new];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont boldSystemFontOfSize:13.f];
    dateLabel.textColor = SYColor(51, 51, 51);
    dateLabel.text = @"日期";
    _dateLabel = dateLabel;
    [self.view addSubview:dateLabel];
    
    UILabel *incomeLabel = [UILabel new];
    incomeLabel.textAlignment = NSTextAlignmentCenter;
    incomeLabel.font = [UIFont boldSystemFontOfSize:13.f];
    incomeLabel.textColor = SYColor(51, 51, 51);
    incomeLabel.text = @"收入（元）";
    _incomeLabel = incomeLabel;
    [self.view addSubview:incomeLabel];
    
    UILabel *stateLabel = [UILabel new];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.font = [UIFont boldSystemFontOfSize:13.f];
    stateLabel.textColor = SYColor(51, 51, 51);
    stateLabel.text = @"状态";
    _stateLabel = stateLabel;
    [self.view addSubview:stateLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#FFFFFF");
    tableView.separatorInset = UIEdgeInsetsZero;
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 30)];
    tipsLabel.backgroundColor = SYColorFromHexString(@"#FFFFFF");
    tipsLabel.text = @"仅显示最近30天数据，更多数据请联系客服";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = SYColor(153, 153, 153);
    tipsLabel.font = SYRegularFont(13);
    tableView.tableFooterView = tipsLabel;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = SY_SCREEN_WIDTH / 3;
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
        make.width.offset(width);
        make.height.offset(15);
    }];
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(self.dateLabel);
        make.left.equalTo(self.dateLabel.mas_right);
        make.width.offset(width);
    }];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(self.dateLabel);
        make.left.equalTo(self.incomeLabel.mas_right);
        make.width.offset(width);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(15);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.model.statisticsDetails.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = self.viewModel.model.statisticsDetails[indexPath.row];
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? SYColor(248, 248, 248) : SYColor(255, 255, 255);
    
    UILabel *dateContentLabel = [UILabel new];
    dateContentLabel.textAlignment = NSTextAlignmentCenter;
    dateContentLabel.font = SYRegularFont(13.f);
    dateContentLabel.textColor = SYColor(102, 102, 102);
    dateContentLabel.text = params[@"datetime"];
    [cell.contentView addSubview:dateContentLabel];
    
    UILabel *incomeContentLabel = [UILabel new];
    incomeContentLabel.textAlignment = NSTextAlignmentCenter;
    incomeContentLabel.font = SYRegularFont(13.f);
    incomeContentLabel.textColor = SYColor(102, 102, 102);
    incomeContentLabel.text = [NSString stringWithFormat:@"%@",params[@"money"]];
    [cell.contentView addSubview:incomeContentLabel];
    
    UILabel *stateContentLabel = [UILabel new];
    stateContentLabel.textAlignment = NSTextAlignmentCenter;
    stateContentLabel.font = SYRegularFont(13.f);
    if ([params[@"status"] isEqualToString:@"已到账"] || [params[@"status"] isEqualToString:@"提现成功"]) {
        stateContentLabel.textColor = SYColor(102, 102, 102);
    } else if ([params[@"status"] isEqualToString:@"未到账"] || [params[@"status"] isEqualToString:@"提现失败"]){
        stateContentLabel.textColor = SYColor(247, 49, 49);
    } else {
        stateContentLabel.textColor = SYColor(249, 220, 58);
    }
    stateContentLabel.text = params[@"status"];
    [cell.contentView addSubview:stateContentLabel];

    [dateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(cell.contentView);
        make.width.offset(SY_SCREEN_WIDTH / 3);
    }];
    [incomeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerY.equalTo(dateContentLabel);
        make.left.equalTo(dateContentLabel.mas_right);
    }];
    [stateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerY.equalTo(incomeContentLabel);
        make.left.equalTo(incomeContentLabel.mas_right);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
