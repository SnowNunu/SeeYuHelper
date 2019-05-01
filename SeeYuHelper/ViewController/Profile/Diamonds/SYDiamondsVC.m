//
//  SYDiamondsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYDiamondsVC.h"

@interface SYDiamondsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *diamondsLabel;

@property (nonatomic, strong) UILabel *diamondsNumberLabel;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYDiamondsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"190钻石",@"price":@"19"},@{@"label":@"300钻石",@"price":@"30"},@{@"label":@"600钻石",@"price":@"60"},@{@"label":@"1000钻石",@"price":@"100"},@{@"label":@"3000钻石",@"price":@"300"},@{@"label":@"5000钻石",@"price":@"500"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
//    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user.userDiamond > 0) {
            self.diamondsNumberLabel.text = [NSString stringWithFormat:@"%d",user.userDiamond];
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
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 135)];
    headerImageView.image = SYImageNamed(@"diamond_bg");
    _headerImageView = headerImageView;
    tableView.tableHeaderView = headerImageView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UILabel *diamondsLabel = [UILabel new];
    diamondsLabel.textColor = [UIColor whiteColor];
    diamondsLabel.textAlignment = NSTextAlignmentLeft;
    diamondsLabel.font = SYRegularFont(16);
    diamondsLabel.text = @"钻石余额";
    _diamondsLabel = diamondsLabel;
    [headerImageView addSubview:diamondsLabel];
    
    UILabel *diamondsNumberLabel = [UILabel new];
    diamondsNumberLabel.textColor = [UIColor whiteColor];
    diamondsNumberLabel.textAlignment = NSTextAlignmentCenter;
    diamondsNumberLabel.font = SYRegularFont(35);
    diamondsNumberLabel.text = @"0";
    _diamondsNumberLabel = diamondsNumberLabel;
    [headerImageView addSubview:diamondsNumberLabel];

}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_diamondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView).offset(15);
        make.top.equalTo(self.headerImageView).offset(30);
        make.height.offset(20);
    }];
    [_diamondsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerImageView);
        make.height.offset(45);
        make.top.equalTo(self.diamondsLabel.mas_bottom).offset(15);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = _dataSource[indexPath.row];
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    [cell.contentView addSubview:lineImageView];
    
    UIImageView *diamondsImageView = [UIImageView new];
    diamondsImageView.image = SYImageNamed(@"icon_diamond");
    [cell.contentView addSubview:diamondsImageView];
    
    UILabel *diamondsAmountLabel = [UILabel new];
    diamondsAmountLabel.textAlignment = NSTextAlignmentLeft;
    diamondsAmountLabel.textColor = SYColor(159, 105, 235);
    diamondsAmountLabel.text = params[@"label"];
    diamondsAmountLabel.font = SYRegularFont(14);
    [cell.contentView addSubview:diamondsAmountLabel];
    
    UILabel *diamondsPriceLabel = [UILabel new];
    diamondsPriceLabel.textAlignment = NSTextAlignmentRight;
    diamondsPriceLabel.textColor = SYColor(153, 153, 153);
    diamondsPriceLabel.text = [NSString stringWithFormat:@"￥%@元",params[@"price"]];
    diamondsPriceLabel.font = SYRegularFont(14);
    [cell.contentView addSubview:diamondsPriceLabel];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(cell.contentView);
        make.height.offset(15);
    }];
    [diamondsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(diamondsAmountLabel);
        make.width.height.offset(15);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    [diamondsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView).offset(-20);
        make.height.offset(20);
        make.left.equalTo(diamondsImageView.mas_right).offset(5);
    }];
    [diamondsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.height.offset(20);
        make.centerY.equalTo(diamondsAmountLabel);
    }];
    return cell;
}

@end
