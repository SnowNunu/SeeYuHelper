//
//  SYLiveDetailsVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLiveDetailsVC.h"

@interface SYLiveDetailsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *dateLabel;

@property (nonatomic ,strong) UILabel *answerTimeLabel;

@property (nonatomic ,strong) UILabel *callTimeLabel;

@property (nonatomic ,strong) UILabel *totalTimeLabel;

@end

@implementation SYLiveDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.reuqestLiveDetailCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array != nil) {
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
    
    UILabel *answerTimeLabel = [UILabel new];
    answerTimeLabel.textAlignment = NSTextAlignmentCenter;
    answerTimeLabel.font = [UIFont boldSystemFontOfSize:13.f];
    answerTimeLabel.textColor = SYColor(51, 51, 51);
    answerTimeLabel.text = @"接听时长";
    _answerTimeLabel = answerTimeLabel;
    [self.view addSubview:answerTimeLabel];
    
    UILabel *callTimeLabel = [UILabel new];
    callTimeLabel.textAlignment = NSTextAlignmentCenter;
    callTimeLabel.font = [UIFont boldSystemFontOfSize:13.f];
    callTimeLabel.textColor = SYColor(51, 51, 51);
    callTimeLabel.text = @"拨打时长";
    _callTimeLabel = callTimeLabel;
    [self.view addSubview:callTimeLabel];
    
    UILabel *totalTimeLabel = [UILabel new];
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    totalTimeLabel.font = [UIFont boldSystemFontOfSize:13.f];
    totalTimeLabel.textColor = SYColor(51, 51, 51);
    totalTimeLabel.text = @"总时长";
    _totalTimeLabel = totalTimeLabel;
    [self.view addSubview:totalTimeLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#FFFFFF");
    tableView.separatorInset = UIEdgeInsetsZero;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.25);
        make.height.offset(45);
    }];
    [_answerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(self.dateLabel);
        make.left.equalTo(self.dateLabel.mas_right);
    }];
    [_callTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(self.dateLabel);
        make.left.equalTo(self.answerTimeLabel.mas_right);
    }];
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(self.dateLabel);
        make.right.equalTo(self.view);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.dateLabel.mas_bottom);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
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
    NSDictionary *params = self.viewModel.datasource[indexPath.row];
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? SYColor(248, 248, 248) : SYColor(255, 255, 255);
    
    UILabel *dateContentLabel = [UILabel new];
    dateContentLabel.textAlignment = NSTextAlignmentCenter;
    dateContentLabel.font = SYRegularFont(13.f);
    dateContentLabel.textColor = SYColor(102, 102, 102);
    dateContentLabel.text = params[@"date"];
    [cell.contentView addSubview:dateContentLabel];
    
    UILabel *answerTimeContentLabel = [UILabel new];
    answerTimeContentLabel.textAlignment = NSTextAlignmentCenter;
    answerTimeContentLabel.font = SYRegularFont(13.f);
    answerTimeContentLabel.textColor = SYColor(102, 102, 102);
    answerTimeContentLabel.text = [NSString stringWithFormat:@"%@分",params[@"answerDuration"]];
    [cell.contentView addSubview:answerTimeContentLabel];
    
    UILabel *callTimeContentLabel = [UILabel new];
    callTimeContentLabel.textAlignment = NSTextAlignmentCenter;
    callTimeContentLabel.font = SYRegularFont(13.f);
    callTimeContentLabel.textColor = SYColor(102, 102, 102);
    callTimeContentLabel.text = [NSString stringWithFormat:@"%@分",params[@"callDuration"]];
    [cell.contentView addSubview:callTimeContentLabel];
    
    UILabel *totalTimeContentLabel = [UILabel new];
    totalTimeContentLabel.textAlignment = NSTextAlignmentCenter;
    totalTimeContentLabel.font = SYRegularFont(13.f);
    totalTimeContentLabel.textColor = SYColor(102, 102, 102);
    totalTimeContentLabel.text = [NSString stringWithFormat:@"%@分",params[@"totalDuration"]];
    [cell.contentView addSubview:totalTimeContentLabel];
    
    [dateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(cell.contentView);
        make.width.equalTo(cell.contentView).multipliedBy(0.25);
        make.height.offset(40);
    }];
    [answerTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.equalTo(dateContentLabel);
        make.left.equalTo(dateContentLabel.mas_right);
    }];
    [callTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.equalTo(dateContentLabel);
        make.left.equalTo(answerTimeContentLabel.mas_right);
    }];
    [totalTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.equalTo(dateContentLabel);
        make.right.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
