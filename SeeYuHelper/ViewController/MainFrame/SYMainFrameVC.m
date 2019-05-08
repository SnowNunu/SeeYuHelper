//
//  SYMainFrameVC.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMainFrameVC.h"
#import "SYUserListModel.h"

@interface SYMainFrameVC () <UITableViewDelegate,UITableViewDataSource>

/// viewModel
@property (nonatomic, readwrite, strong) SYMainFrameVM *viewModel;

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYMainFrameVC

@dynamic viewModel;

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    self.user = viewModel.services.client.currentUser;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestCustomerServiceCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestUserListInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array != nil) {
            [self.tableView reloadData];
        }
    }];
    [SYNotificationCenter addObserver:self selector:@selector(enterCustomerServiceView) name:@"enterCSViewFromMain" object:nil];
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
    return self.viewModel.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYUserListModel *model = self.viewModel.datasource[indexPath.row];
    
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.layer.cornerRadius = 35.f;
    avatarImageView.masksToBounds = YES;
    [avatarImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYImageNamed(@"DefaultProfileHead_66x66") options:SYWebImageOptionAutomatic completion:NULL];
    [cell.contentView addSubview:avatarImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font = SYRegularFont(18);
    aliasLabel.textColor = SYColor(51, 51, 51);
    aliasLabel.text = model.userName;
    [cell.contentView addSubview:aliasLabel];
    
    UIImageView *vipImageView = [UIImageView new];
    vipImageView.image = model.userVipStatus == 0 ? SYImageNamed(@"VIP_disable") : SYImageNamed(@"VIP");
    [cell.contentView addSubview:vipImageView];
    
    UILabel *diamondsLabel = [UILabel new];
    diamondsLabel.textAlignment = NSTextAlignmentRight;
    diamondsLabel.textColor = SYColor(159, 105, 235);
    diamondsLabel.font = SYRegularFont(14);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"钻石：%d",model.userDiamond]];
    [str addAttribute: NSForegroundColorAttributeName value: SYColor(51, 51, 51) range: NSMakeRange(0, 3)];
    diamondsLabel.attributedText = str;
    [cell.contentView addSubview:diamondsLabel];
    
    UILabel *followStateLabel = [UILabel new];
    followStateLabel.textAlignment = NSTextAlignmentLeft;
    followStateLabel.font = SYRegularFont(14);
    if (model.followFlag == 1) {
        followStateLabel.text = @"已关注我";
        followStateLabel.textColor = SYColor(159, 105, 235);
    } else {
        followStateLabel.text = @"未关注我";
        followStateLabel.textColor = SYColor(51, 51, 51);
    }
    [cell.contentView addSubview:followStateLabel];
    
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(70);
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.mas_right).offset(15);
        make.top.equalTo(avatarImageView);
        make.height.offset(35);
    }];
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aliasLabel.mas_right).offset(15);
        make.centerY.equalTo(aliasLabel);
        make.width.offset(40);
        make.height.offset(20);
    }];
    [diamondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(aliasLabel);
        make.bottom.equalTo(avatarImageView);
    }];
    [followStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(diamondsLabel.mas_right).offset(30);
        make.centerY.height.equalTo(diamondsLabel);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYUserListModel *model = self.viewModel.datasource[indexPath.row];
    [self.viewModel.enterUserInfoViewCommand execute:model.userId];
}

- (void)enterCustomerServiceView {
    SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    NSString *targetId = @"";
    YYCache *cache = [YYCache cacheWithName:@"SeeYuHelper"];
    if ([cache containsObjectForKey:@"customerUserId"]) {
        id customerUserId = [cache objectForKey:@"customerUserId"];
        targetId = (NSString *)customerUserId;
    } else {
        targetId = @"12404";
    }
    conversationVC.targetId = targetId;
    conversationVC.title = @"客服";
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
