//
//  SYLiveStatisticsVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYLiveStatisticsVC.h"
#import "SYLiveInfoModel.h"

@interface SYLiveStatisticsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *infoBgView;

@property (nonatomic, strong) UILabel *totalTimeTitleLabel;

@property (nonatomic, strong) UILabel *totalTimeContentLabel;

@property (nonatomic, strong) UILabel *answerTimeTitleLabel;

@property (nonatomic, strong) UILabel *answerTimeContentLabel;

@property (nonatomic, strong) UILabel *callTimeTitleLabel;

@property (nonatomic, strong) UILabel *callTimeContentLabel;

@property (nonatomic, strong) UILabel *planTimeTitleLabel;

@property (nonatomic, strong) UILabel *planTimeContentLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *moreInfoBtn;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation SYLiveStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.reuqestLiveInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, liveInfo) subscribeNext:^(SYLiveInfoModel *model) {
        @strongify(self)
        if (model != nil) {
            self.totalTimeContentLabel.text = [NSString stringWithFormat:@"%d分",model.totalDuration];
            self.answerTimeContentLabel.text = [NSString stringWithFormat:@"%d分",model.answerDuration];
            self.callTimeContentLabel.text = [NSString stringWithFormat:@"%d分",model.callDuration];
            self.planTimeContentLabel.text = [NSString stringWithFormat:@"%d分",model.baseDuration];
            [self.tableView reloadData];
        }
    }];
    [[self.moreInfoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.enterLiveDetailViewCommand execute:nil];
    }];
}

- (void)_setupSubViews {
    // 背景图片
    UIImageView *infoBgView = [UIImageView new];
    infoBgView.image = SYImageNamed(@"liveBgView");
    _infoBgView = infoBgView;
    [self.view addSubview:infoBgView];
    
    // 总时长
    UILabel *totalTimeTitleLabel = [UILabel new];
    totalTimeTitleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    totalTimeTitleLabel.textColor = SYColor(255, 255, 255);
    totalTimeTitleLabel.text = @"总时长";
    _totalTimeTitleLabel = totalTimeTitleLabel;
    [infoBgView addSubview:totalTimeTitleLabel];
    
    // 总时长数值
    UILabel *totalTimeContentLabel = [UILabel new];
    totalTimeContentLabel.font = SYRegularFont(17);
    totalTimeContentLabel.textColor = SYColor(255, 255, 255);
    totalTimeContentLabel.text = @"0分";
    _totalTimeContentLabel = totalTimeContentLabel;
    [infoBgView addSubview:totalTimeContentLabel];
    
    // 接听时长
    UILabel *answerTimeTitleLabel = [UILabel new];
    answerTimeTitleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    answerTimeTitleLabel.textColor = SYColor(255, 255, 255);
    answerTimeTitleLabel.text = @"接听时长";
    _answerTimeTitleLabel = answerTimeTitleLabel;
    [infoBgView addSubview:answerTimeTitleLabel];
    
    // 接听时长数值
    UILabel *answerTimeContentLabel = [UILabel new];
    answerTimeContentLabel.font = SYRegularFont(17);
    answerTimeContentLabel.textColor = SYColor(255, 255, 255);
    answerTimeContentLabel.text = @"0分";
    _answerTimeContentLabel = answerTimeContentLabel;
    [infoBgView addSubview:answerTimeContentLabel];
    
    // 拨打时长
    UILabel *callTimeTitleLabel = [UILabel new];
    callTimeTitleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    callTimeTitleLabel.textColor = SYColor(255, 255, 255);
    callTimeTitleLabel.text = @"拨打时长";
    _callTimeTitleLabel = callTimeTitleLabel;
    [infoBgView addSubview:callTimeTitleLabel];
    
    // 接听时长数值
    UILabel *callTimeContentLabel = [UILabel new];
    callTimeContentLabel.font = SYRegularFont(17);
    callTimeContentLabel.textColor = SYColor(255, 255, 255);
    callTimeContentLabel.text = @"0分";
    _callTimeContentLabel = callTimeContentLabel;
    [infoBgView addSubview:callTimeContentLabel];
    
    // 计划时长
    UILabel *planTimeTitleLabel = [UILabel new];
    planTimeTitleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    planTimeTitleLabel.textColor = SYColor(255, 255, 255);
    planTimeTitleLabel.text = @"计划时长";
    _planTimeTitleLabel = planTimeTitleLabel;
    [infoBgView addSubview:planTimeTitleLabel];
    
    // 计划时长数值
    UILabel *planTimeContentLabel = [UILabel new];
    planTimeContentLabel.font = SYRegularFont(17);
    planTimeContentLabel.textColor = SYColor(255, 255, 255);
    planTimeContentLabel.text = @"0分";
    _planTimeContentLabel = planTimeContentLabel;
    [infoBgView addSubview:planTimeContentLabel];
    
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
    
    // 时长
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = SYRegularFont(17);
    timeLabel.textColor = SYColor(159, 105, 235);
    timeLabel.text = @"时长（分）";
    timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel = timeLabel;
    [self.view addSubview:timeLabel];
    
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
    [_infoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.offset(143);
    }];
    [_totalTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.infoBgView).offset(15);
        make.height.offset(20);
    }];
    [_totalTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalTimeTitleLabel);
        make.top.equalTo(self.totalTimeTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_answerTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(15);
        make.top.equalTo(self.totalTimeContentLabel.mas_bottom).offset(30);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_answerTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerTimeTitleLabel);
        make.top.equalTo(self.answerTimeTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_callTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.infoBgView);
        make.top.equalTo(self.answerTimeTitleLabel);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_callTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.callTimeTitleLabel);
        make.top.equalTo(self.callTimeTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_planTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.infoBgView).offset(-15);
        make.top.equalTo(self.answerTimeTitleLabel);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_planTimeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.planTimeTitleLabel);
        make.top.equalTo(self.planTimeTitleLabel.mas_bottom).offset(9);
        make.height.offset(15);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoBgView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(30);
        make.height.offset(20);
    }];
    [_moreInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoBgView.mas_bottom).offset(60);
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
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return self.viewModel.liveInfo.videoDurationDay.count;
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
    NSDictionary *params = self.viewModel.liveInfo.videoDurationDay[indexPath.row];

    UILabel *dateContentLabel = [UILabel new];
    dateContentLabel.text = params[@"date"];
    dateContentLabel.textAlignment = NSTextAlignmentLeft;
    dateContentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:dateContentLabel];
    
    UILabel *timeContentLabel = [UILabel new];
    timeContentLabel.text = [NSString stringWithFormat:@"%@",params[@"minute_num"]];
    timeContentLabel.textAlignment = NSTextAlignmentCenter;
    timeContentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:timeContentLabel];
    
    [dateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(60);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
        make.width.offset(95);
    }];
    [timeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
