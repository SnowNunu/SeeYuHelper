//
//  SYNewFriendsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYNewFriendsVC.h"
#import "SYNewFriendModel.h"

@interface SYNewFriendsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYNewFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestNewFriendsCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *usersArray) {
        if (usersArray.count > 0) {
            [self.tableView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"friendsInfoViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYNewFriendModel *model = self.viewModel.datasource[indexPath.row];
    
    // 好友头像
    UIImageView *avatarView = [UIImageView new];
    avatarView.layer.cornerRadius = 22.5f;
    avatarView.clipsToBounds = YES;
    [avatarView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYDefaultAvatar(SYDefaultAvatarTypeDefualt) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask completion:nil];
    [cell.contentView addSubview:avatarView];
    
    // 好友昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.text = model.userFriendName;
    aliasLabel.font = SYRegularFont(16);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:aliasLabel];
    
    // 好友ID
    UILabel *idLabel = [UILabel new];
    idLabel.text = [NSString stringWithFormat:@"ID：%@",model.userFriendId];
    idLabel.font = SYRegularFont(14);
    idLabel.textColor = SYColor(153, 153, 153);
    idLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:idLabel];
    
    // 同意按钮按钮
    UIButton *agreeFriendBtn = [UIButton new];
    [agreeFriendBtn setBackgroundColor:SYColorFromHexString(@"#9F69EB")];
    [agreeFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeFriendBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeFriendBtn.layer.cornerRadius = 5.f;
    agreeFriendBtn.layer.masksToBounds = YES;
    [[agreeFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.agreeFriendRequestCommand execute:model.userFriendId];
    }];
    [cell.contentView addSubview:agreeFriendBtn];
    
    // 目前好友关系状态
    UILabel *relationStatusLabel = [UILabel new];
    relationStatusLabel.font = SYRegularFont(14);
    relationStatusLabel.textColor = SYColor(153, 153, 153);
    relationStatusLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:relationStatusLabel];
    
    if ([model.relation_status isEqualToString:@"2"]) {
        relationStatusLabel.hidden = YES;
        agreeFriendBtn.hidden = NO;
    } else {
        relationStatusLabel.hidden = NO;
        agreeFriendBtn.hidden = YES;
        if ([model.relation_status isEqualToString:@"1"]) {
            relationStatusLabel.text = @"已通过";
        } else {
            relationStatusLabel.text = @"已删除";
        }
    }
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(15);
        make.right.equalTo(agreeFriendBtn.mas_left).offset(-15);
        make.top.equalTo(avatarView);
        make.height.offset(20);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(aliasLabel);
        make.bottom.equalTo(avatarView);
    }];
    [agreeFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(70);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(30);
    }];
    [relationStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(agreeFriendBtn);
    }];
    return cell;
}

@end
