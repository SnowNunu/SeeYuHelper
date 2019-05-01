//
//  SYProfileVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYProfileVC.h"
#import "NSDate+Extension.h"

@interface SYProfileVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UIButton *detailBtn;

@property (nonatomic, strong) UIView *vipBgView;

@property (nonatomic, strong) UIImageView *vipImageView;

@property (nonatomic, strong) UILabel *vipLabel;

@property (nonatomic, strong) UIImageView *separateImageView;

@property (nonatomic, strong) UIView *authenticationBgView;

@property (nonatomic, strong) UIImageView *authenticationImageView;

@property (nonatomic, strong) UILabel *authenticationLabel;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"我的动态",@"icon":@"icon_moment"},@{@"label":@"我的礼物",@"icon":@"icon_gift"},@{@"label":@"我的聊豆",@"icon":@"icon_chatBean"},@{@"label":@"我的钻石",@"icon":@"icon_diamond"},@{@"label":@"设置",@"icon":@"icon_setting"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestUserInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        @strongify(self)
        if (![user.userName sy_isNullOrNil] && user.userName.length > 0) {
            self.aliasLabel.text = user.userName;
        }
        if (![user.userSignature sy_isNullOrNil] && user.userSignature.length > 0) {
            self.signatureLabel.text = user.userSignature;
        }
        if (![user.userHeadImg sy_isNullOrNil] && user.userHeadImg.length > 0) {
            [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }
        if (user.userVipStatus == 1) {
            if (user.userVipExpiresAt != nil) {
                NSComparisonResult result = [user.userVipExpiresAt compare:[NSDate date]];
                if (result == NSOrderedDescending) {
                    // 会员未过期
                    self.vipImageView.image = SYImageNamed(@"VIP");
                } else {
                    // 会员已过期的情况
                    self.vipImageView.image = SYImageNamed(@"VIP_disable");
                }
            }
        } else {
            self.vipImageView.image = SYImageNamed(@"VIP_disable");
        }
        if (user.identityStatus == 1) {
            self.authenticationImageView.image = SYImageNamed(@"truePerson");
        } else {
            self.authenticationImageView.image = SYImageNamed(@"truePerson_disable");
        }
        if (user.userRegisterTime != nil) {
            NSTimeInterval seconds = [[NSDate new] timeIntervalSinceDate:user.userRegisterTime];//间隔的秒数
            if (seconds > 7 * 24 * 3600) {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"btn_checkin_cricle" target:self selector:@selector(openSigninView) textType:NO];
            }
        }
    }];
    [[self.detailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.enterNextViewCommand execute:@(7)];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.separatorInset = UIEdgeInsetsZero;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 180)];
    headerView.backgroundColor = [UIColor whiteColor];
    _headerView = headerView;
    tableView.tableHeaderView = headerView;
    UITapGestureRecognizer *infoTap = [UITapGestureRecognizer new];
    [[infoTap rac_gestureSignal] subscribeNext:^(id x) {
        [self.viewModel.enterNextViewCommand execute:@(7)];
    }];
    [headerView addGestureRecognizer:infoTap];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    //用户头像
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.image = SYImageNamed(@"DefaultProfileHead_66x66");
    avatarImageView.layer.cornerRadius = 30.f;
    avatarImageView.clipsToBounds = YES;
    _avatarImageView = avatarImageView;
    [headerView addSubview:avatarImageView];
    
    // 用户昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.textColor = SYColor(51, 51, 51);
    aliasLabel.font = SYRegularFont(17);
    _aliasLabel = aliasLabel;
    [headerView addSubview:aliasLabel];
    
    // 用户签名
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.textColor = SYColor(153, 153, 153);
    signatureLabel.font = SYRegularFont(14);
    _signatureLabel = signatureLabel;
    [headerView addSubview:signatureLabel];
    
    // 用户信息详情
    UIButton *detailBtn = [UIButton new];
    [detailBtn setImage:SYImageNamed(@"detail_back") forState:UIControlStateNormal];
    _detailBtn = detailBtn;
    [headerView addSubview:detailBtn];
    
    // vip状态背景
    UIView *vipBgView = [UIView new];
    _vipBgView = vipBgView;
    [headerView addSubview:vipBgView];
    UITapGestureRecognizer *vipTap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[vipTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(5)];
    }];
    [vipBgView addGestureRecognizer:vipTap];
    
    // vip状态
    UIImageView *vipImageView = [UIImageView new];
    vipImageView.image = SYImageNamed(@"VIP_disable");
    _vipImageView = vipImageView;
    [headerView addSubview:vipImageView];
    
    // vip tips
    UILabel *vipLabel = [UILabel new];
    vipLabel.font = SYRegularFont(14);
    vipLabel.textAlignment = NSTextAlignmentCenter;
    vipLabel.textColor = SYColor(51, 51, 51);
    vipLabel.text = @"VIP特权";
    _vipLabel = vipLabel;
    [headerView addSubview:vipLabel];
    
    // 分隔线
    UIImageView *separateImageView = [UIImageView new];
    separateImageView.backgroundColor = SYColor(153, 153, 153);
    _separateImageView = separateImageView;
    [headerView addSubview:separateImageView];
    
    // 真人认证状态背景
    UIView *authenticationBgView = [UIView new];
    _authenticationBgView = authenticationBgView;
    [headerView addSubview:authenticationBgView];
    UITapGestureRecognizer *authenticationTap = [[UITapGestureRecognizer alloc] init];
    [[authenticationTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(6)];
    }];
    [authenticationBgView addGestureRecognizer:authenticationTap];
    
    // 真人认证状态
    UIImageView *authenticationImageView = [UIImageView new];
    authenticationImageView.image = SYImageNamed(@"truePerson_disable");
    _authenticationImageView = authenticationImageView;
    [headerView addSubview:authenticationImageView];
    
    // authentication tips
    UILabel *authenticationLabel = [UILabel new];
    authenticationLabel.font = SYRegularFont(14);
    authenticationLabel.textAlignment = NSTextAlignmentCenter;
    authenticationLabel.textColor = SYColor(51, 51, 51);
    authenticationLabel.text = @"真人认证";
    _authenticationLabel = authenticationLabel;
    [headerView addSubview:authenticationLabel];
    
    // 底部分隔区域
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _lineImageView = lineImageView;
    [headerView addSubview:lineImageView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.left.top.equalTo(self.headerView).offset(15);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
        make.height.offset(20);
        make.bottom.equalTo(self.avatarImageView).offset(-37.5);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.aliasLabel);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
    }];
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(10);
        make.height.offset(20);
        make.centerY.equalTo(self.avatarImageView);
        make.right.equalTo(self.headerView).offset(-15);
    }];
    [_vipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineImageView.mas_top);
        make.left.equalTo(self.lineImageView);
        make.width.offset(SY_SCREEN_WIDTH / 2);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(15);
    }];
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipBgView).offset(15);
        make.height.offset(30);
        make.width.offset(60);
        make.centerX.equalTo(self.vipBgView);
    }];
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vipImageView);
        make.top.equalTo(self.vipImageView.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [_separateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lineImageView);
        make.width.offset(1);
        make.centerY.equalTo(self.vipBgView);
        make.height.offset(49);
    }];
    [_authenticationBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(self.vipBgView);
        make.right.equalTo(self.headerView);
    }];
    [_authenticationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.vipImageView);
        make.width.offset(70);
        make.centerX.equalTo(self.authenticationBgView);
    }];
    [_authenticationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.authenticationImageView);
        make.top.equalTo(self.authenticationImageView.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerView);
        make.height.offset(15);
    }];
}

- (void)openSigninView {
    SYSigninVM *signVM = [[SYSigninVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
    SYSigninVC *signVC = [[SYSigninVC alloc] initWithViewModel:signVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:signVC withAnimation:animation];
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
