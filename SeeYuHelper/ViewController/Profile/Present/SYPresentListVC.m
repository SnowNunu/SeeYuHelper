//
//  SYPresentListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPresentListVC.h"
#import "SYPresentModel.h"

@interface SYPresentListVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SYPresentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestPresentsListCommand execute:nil];
}

- (void)bindViewModel {
    [RACObserve(self.viewModel, presentsArray) subscribeNext:^(NSArray *array) {
        [self.tableView reloadData];
    }];
}

- (void)_setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.presentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYPresentModel *model = self.viewModel.presentsArray[indexPath.row];
    cell.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    
    // 礼物图片
    UIImageView *avatarImageView = [UIImageView new];
    [avatarImageView yy_setImageWithURL:[NSURL URLWithString:model.giftImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
    [cell.contentView addSubview:avatarImageView];
    
    // 礼物名称&数量
    UILabel *presentLabel = [UILabel new];
    presentLabel.textColor = SYColor(51, 51, 51);
    presentLabel.font = SYRegularFont(18);
    presentLabel.textAlignment = NSTextAlignmentLeft;
    presentLabel.text = [NSString stringWithFormat:@"%@ x%@",model.giftName,model.giveGiftNumber];
    [cell.contentView addSubview:presentLabel];
    
    // 昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = SYColor(153, 153, 153);
    aliasLabel.font = SYRegularFont(14);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.text = model.userName;
    [cell.contentView addSubview:aliasLabel];
    
    // 钻石数量
    UILabel *diamondsAmountLabel = [UILabel new];
    diamondsAmountLabel.textColor = SYColor(159, 105, 235);
    diamondsAmountLabel.font = SYRegularFont(14);
    diamondsAmountLabel.textAlignment = NSTextAlignmentLeft;
    diamondsAmountLabel.text = [NSString stringWithFormat:@"%@钻石",model.userDiamond];
    [cell.contentView addSubview:diamondsAmountLabel];
    
    // 星期
    UILabel *weekdayLabel = [UILabel new];
    weekdayLabel.textColor = SYColor(153, 153, 153);
    weekdayLabel.font = SYRegularFont(16);
    weekdayLabel.textAlignment = NSTextAlignmentRight;
    weekdayLabel.text = model.giveDateWeek;
    [cell.contentView addSubview:weekdayLabel];
    
    // 日期
    UILabel *dateLabel = [UILabel new];
    dateLabel.textColor = SYColor(159, 105, 235);
    dateLabel.font = SYRegularFont(14);
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.text = model.giveDate;
    [cell.contentView addSubview:dateLabel];
    
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40);
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
    }];
    [presentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarImageView);
        make.left.equalTo(avatarImageView.mas_right).offset(30);
        make.height.offset(20);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(avatarImageView);
        make.left.height.equalTo(presentLabel);
    }];
    [diamondsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(SY_SCREEN_WIDTH / 2);
        make.bottom.height.equalTo(aliasLabel);
    }];
    [weekdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.height.offset(20);
        make.centerY.equalTo(presentLabel);
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(aliasLabel);
        make.right.equalTo(weekdayLabel);
    }];
    return cell;
}

@end
