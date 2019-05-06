//
//  SYProfileVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYProfileVC.h"
#import "NSDate+Extension.h"
#import "SYUserDetail.h"

@interface SYProfileVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIView *focusBgView;

@property (nonatomic, strong) UILabel *focusTitleLabel;

@property (nonatomic, strong) UILabel *focusContentLabel;

@property (nonatomic, strong) UIView *giftBgView;

@property (nonatomic, strong) UILabel *giftTitleLabel;

@property (nonatomic, strong) UILabel *giftContentLabel;

@property (nonatomic, strong) UIView *commissionBgView;

@property (nonatomic, strong) UILabel *commissionTitleLabel;

@property (nonatomic, strong) UILabel *commissionContentLabel;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"帐号信息",@"icon":@"accountInfo"},@{@"label":@"个人资料",@"icon":@"selfInfo"},@{@"label":@"工作时间",@"icon":@"workTime"},@{@"label":@"数据统计",@"icon":@"dataCount"},@{@"label":@"设置",@"icon":@"setting"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestUserBaseInfoCommand execute:nil];
    [self.viewModel.requestUserDetailInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        @strongify(self)
        if (![user.userHeadImg sy_isNullOrNil] && user.userHeadImg.length > 0) {
            [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }
    }];
    [RACObserve(self.viewModel, userDetail) subscribeNext:^(SYUserDetail *userDetail) {
        @strongify(self)
        if (userDetail != nil) {
            self.focusContentLabel.text = [NSString stringWithFormat:@"%d",userDetail.followNum];
            self.giftContentLabel.text = [NSString stringWithFormat:@"%d",userDetail.giftNum];
            self.commissionContentLabel.text = [NSString stringWithFormat:@"￥%d",userDetail.basePay];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 190)];
    headerView.backgroundColor = [UIColor whiteColor];
    _headerView = headerView;
    tableView.tableHeaderView = headerView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    //用户头像
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.image = SYImageNamed(@"DefaultProfileHead_66x66");
    avatarImageView.layer.cornerRadius = 30.f;
    avatarImageView.clipsToBounds = YES;
    _avatarImageView = avatarImageView;
    [headerView addSubview:avatarImageView];
    
    // 关注背景
    UIView *focusBgView = [UIView new];
    _focusBgView = focusBgView;
    [headerView addSubview:focusBgView];
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[focusTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(5)];
    }];
    [focusBgView addGestureRecognizer:focusTap];
    
    UILabel *focusContentLabel = [UILabel new];
    focusContentLabel.textAlignment = NSTextAlignmentCenter;
    focusContentLabel.font = [UIFont boldSystemFontOfSize:20];
    focusContentLabel.textColor = SYColor(51, 51, 51);
    focusContentLabel.text = @"0";
    _focusContentLabel = focusContentLabel;
    [focusBgView addSubview:focusContentLabel];
    
    UILabel *focusTitleLabel = [UILabel new];
    focusTitleLabel.textAlignment = NSTextAlignmentCenter;
    focusTitleLabel.font = SYRegularFont(14);
    focusTitleLabel.textColor = SYColor(51, 51, 51);
    focusTitleLabel.text = @"关注";
    _focusTitleLabel = focusTitleLabel;
    [focusBgView addSubview:focusTitleLabel];
    
    // 礼物背景
    UIView *giftBgView = [UIView new];
    _giftBgView = giftBgView;
    [headerView addSubview:giftBgView];
    UITapGestureRecognizer *giftTap = [[UITapGestureRecognizer alloc] init];
    [[giftTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(6)];
    }];
    [giftBgView addGestureRecognizer:giftTap];
    
    UILabel *giftContentLabel = [UILabel new];
    giftContentLabel.textAlignment = NSTextAlignmentCenter;
    giftContentLabel.font = [UIFont boldSystemFontOfSize:20];
    giftContentLabel.textColor = SYColor(51, 51, 51);
    giftContentLabel.text = @"0";
    _giftContentLabel = giftContentLabel;
    [giftBgView addSubview:giftContentLabel];
    
    UILabel *giftTitleLabel = [UILabel new];
    giftTitleLabel.textAlignment = NSTextAlignmentCenter;
    giftTitleLabel.font = SYRegularFont(14);
    giftTitleLabel.textColor = SYColor(51, 51, 51);
    giftTitleLabel.text = @"礼物";
    _giftTitleLabel = giftTitleLabel;
    [giftBgView addSubview:giftTitleLabel];
    
    // 佣金背景
    UIView *commissionBgView = [UIView new];
    _commissionBgView = commissionBgView;
    [headerView addSubview:commissionBgView];
    UITapGestureRecognizer *commissionTap = [[UITapGestureRecognizer alloc] init];
    [[commissionTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(7)];
    }];
    [commissionBgView addGestureRecognizer:commissionTap];
    
    UILabel *commissionContentLabel = [UILabel new];
    commissionContentLabel.textAlignment = NSTextAlignmentCenter;
    commissionContentLabel.font = [UIFont boldSystemFontOfSize:20];
    commissionContentLabel.textColor = SYColor(51, 51, 51);
    commissionContentLabel.text = @"￥0";
    _commissionContentLabel = commissionContentLabel;
    [commissionBgView addSubview:commissionContentLabel];
    
    UILabel *commissionTitleLabel = [UILabel new];
    commissionTitleLabel.textAlignment = NSTextAlignmentCenter;
    commissionTitleLabel.font = SYRegularFont(14);
    commissionTitleLabel.textColor = SYColor(51, 51, 51);
    commissionTitleLabel.text = @"佣金";
    _commissionTitleLabel = commissionTitleLabel;
    [commissionBgView addSubview:commissionTitleLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = SY_SCREEN_WIDTH / 3;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.top.equalTo(self.headerView).offset(15);
        make.centerX.equalTo(self.headerView);
    }];
    [_focusBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(30);
        make.width.offset(width);
        make.height.offset(65);
    }];
    [_focusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.focusBgView);
        make.height.offset(15);
    }];
    [_focusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.focusContentLabel.mas_bottom).offset(20);
        make.centerX.height.equalTo(self.focusContentLabel);
    }];
    [_giftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.focusBgView);
        make.left.equalTo(self.focusBgView.mas_right);
        make.width.offset(width);
    }];
    [_giftContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.giftBgView);
        make.height.offset(15);
    }];
    [_giftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftContentLabel.mas_bottom).offset(20);
        make.centerX.height.equalTo(self.giftContentLabel);
    }];
    [_commissionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.focusBgView);
        make.right.equalTo(self.headerView);
        make.width.offset(width);
    }];
    [_commissionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.commissionBgView);
        make.height.offset(15);
    }];
    [_commissionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commissionContentLabel.mas_bottom).offset(20);
        make.centerX.height.equalTo(self.commissionContentLabel);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = _dataSource[indexPath.row];
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = SYImageNamed(params[@"icon"]);
    [cell.contentView addSubview:iconImageView];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = params[@"label"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:contentLabel];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
        make.width.height.offset(16);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.right.equalTo(cell.contentView).offset(-15);
        make.centerY.equalTo(iconImageView);
        make.height.offset(20);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.viewModel.enterNextViewCommand execute:@(indexPath.row)];
}

@end
