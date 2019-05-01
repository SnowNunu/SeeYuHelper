//
//  SYAddFriendsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAddFriendsVC.h"

@interface SYAddFriendsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UIView *idTextBgView;

@property (nonatomic, strong) UITextField *idTextField;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYAddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _sendRequest = NO;
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.idTextField.text.length > 0) {
            self.sendRequest = YES;
            [self.viewModel.searchFriendsCommand execute:self.idTextField.text];
        } else {
            [MBProgressHUD sy_showTips:@"请先输入好友昵称或者id"];
        }
    }];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *usersArray) {
        if (usersArray.count > 0) {
            [self.tableView reloadData];
        } else {
            if (self.sendRequest) {
                [MBProgressHUD sy_showError:@"未查询到该好友"];
            }
        }
    }];
}

- (void)_setupSubViews {
    UIButton *searchBtn = [UIButton new];
    searchBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTintColor:[UIColor whiteColor]];
    _searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
    
    UIView *idTextBgView = [UIView new];
    idTextBgView.backgroundColor = SYColorFromHexString(@"#9F69EB");
    _idTextBgView = idTextBgView;
    [self.view addSubview:idTextBgView];
    
    UITextField *idTextField = [UITextField new];
    idTextField.placeholder = @"用户ID/用户昵称";
    idTextField.layer.cornerRadius = 5.f;
    idTextField.backgroundColor = [UIColor whiteColor];
    idTextField.textAlignment = NSTextAlignmentCenter;
    _idTextField = idTextField;
    [self.view addSubview:idTextField];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    [self.idTextBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.view);
        make.height.offset(50);
    }];
    [self.idTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.idTextBgView);
        make.height.offset(30);
        make.width.equalTo(self.idTextBgView).offset(-15);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.top.equalTo(self.idTextBgView.mas_bottom);
        make.bottom.equalTo(self.searchBtn.mas_top);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYUser *user = self.viewModel.datasource[indexPath.row];
    
    // 好友头像
    UIImageView *avatarView = [UIImageView new];
    avatarView.layer.cornerRadius = 22.5f;
    avatarView.clipsToBounds = YES;
    [avatarView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYDefaultAvatar(SYDefaultAvatarTypeDefualt) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask completion:nil];
    [cell.contentView addSubview:avatarView];
    
    // 好友昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.text = user.userName;
    aliasLabel.font = SYRegularFont(16);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:aliasLabel];
    
    // 好友ID
    UILabel *idLabel = [UILabel new];
    idLabel.text = [NSString stringWithFormat:@"ID：%@",user.userId];
    idLabel.font = SYRegularFont(14);
    idLabel.textColor = SYColor(153, 153, 153);
    idLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:idLabel];
    
    // 添加还有按钮
    UIButton *addFriendBtn = [UIButton new];
    [addFriendBtn setBackgroundColor:SYColorFromHexString(@"#9F69EB")];
    [addFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addFriendBtn setTitle:@"添加" forState:UIControlStateNormal];
    addFriendBtn.layer.cornerRadius = 5.f;
    addFriendBtn.layer.masksToBounds = YES;
    [[addFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.addFriendRequestCommand execute:user.userId];
    }];
    [cell.contentView addSubview:addFriendBtn];
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(15);
        make.right.equalTo(addFriendBtn.mas_left).offset(-15);
        make.top.equalTo(avatarView);
        make.height.offset(20);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(aliasLabel);
        make.bottom.equalTo(avatarView);
    }];
    [addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(70);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(30);
    }];
    return cell;
}

@end
