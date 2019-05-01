//
//  SYMyMomentsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMyMomentsVC.h"

@interface SYMyMomentsVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *currentYearLabel;

@property (nonatomic, strong) UILabel *currentDayLabel;

@property (nonatomic, strong) UIImageView *uploadImageView;

@end

@implementation SYMyMomentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestAllMineMomentsCommand execute:nil];
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.separatorInset = UIEdgeInsetsZero;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIView *headerView = [UIView new];
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:headerView];
    
    UILabel *currentYearLabel = [UILabel new];
    currentYearLabel.font = SYRegularFont(32);
    currentYearLabel.textColor = SYColor(51, 51, 51);
    currentYearLabel.textAlignment = NSTextAlignmentLeft;
    currentYearLabel.text = [NSString stringWithFormat:@"%@年",[NSDate sy_currentYear]];
    _currentYearLabel = currentYearLabel;
    [headerView addSubview:currentYearLabel];
    
    UILabel *currentDayLabel = [UILabel new];
    currentDayLabel.font = SYRegularFont(30);
    currentDayLabel.textColor = SYColor(51, 51, 51);
    currentDayLabel.textAlignment = NSTextAlignmentLeft;
    currentDayLabel.text = @"今天";
    _currentDayLabel = currentDayLabel;
    [headerView addSubview:currentDayLabel];
    
    UIImageView *uploadImageView = [UIImageView new];
    uploadImageView.image = SYImageNamed(@"btn_addMoment");
    uploadImageView.userInteractionEnabled = YES;
    _uploadImageView = uploadImageView;
    [headerView addSubview:uploadImageView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tableView);
        make.bottom.equalTo(self.uploadImageView);
    }];
    [_currentYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(30);
        make.left.equalTo(self.headerView).offset(15);
        make.height.offset(30);
    }];
    [_currentDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentYearLabel);
        make.height.offset(30);
        make.top.equalTo(self.currentYearLabel.mas_bottom).offset(15);
    }];
    [_uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentDayLabel.mas_right).offset(15);
        make.width.height.offset(80);
        make.top.equalTo(self.currentDayLabel);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.yearArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.viewModel.datasource[section - 1];
    NSLog(@"%@",self.viewModel.datasource);
    NSLog(@"%@",self.viewModel.datasource[section]);
    return 0;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [UIView new];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    } else {
//        return 15.f;
//    }
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
