//
//  SYRankListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYRankListVC.h"

@interface SYRankListVC ()

@property (nonatomic, strong) SYRankListVM *viewModel;

@end

@implementation SYRankListVC

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
        @weakify(self)
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(self)
            /// 请求第一页的网络数据
            [self.viewModel.requestRankListCommand execute:nil];
        }];
    }
    return self;
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[RACObserve(self.viewModel, dataSource)
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         // 刷新数据
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
}

- (void)_setupSubViews {
    SYTableView *tableView = [[SYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // 添加下拉刷新控件
    @weakify(self);
    [self.tableView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self.viewModel.requestRankListCommand execute:nil];
        [self.tableView.mj_header beginRefreshing];
    }];
    
    if (@available(iOS 11.0, *)) {
        SYAdjustsScrollViewInsets_Never(tableView);
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(SY_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    CGFloat itemMargin = (SY_SCREEN_WIDTH - 180) / 4;
    if (indexPath.row == 0) {
        for (int i = 0; i < 3; i++) {
            SYRankListModel *model = self.viewModel.dataSource[i];
            UIImageView *headImageView = [UIImageView new];
            [headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
            [cell addSubview:headImageView];
            
            UIImageView *backImageView = [UIImageView new];
            backImageView.userInteractionEnabled = YES;
            backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_Head frame_%d",i]];
            [cell addSubview:backImageView];
            [cell bringSubviewToFront:backImageView];
            
            if (i == 0) {
                headImageView.layer.cornerRadius = 35.f;
            } else {
                headImageView.layer.cornerRadius = 20.f;
            }
            headImageView.layer.masksToBounds = YES;
            
            UILabel *aliasLabel = [UILabel new];
            aliasLabel.text = model.userName;
            aliasLabel.textAlignment = NSTextAlignmentCenter;
            aliasLabel.font = SYRegularFont(17);
            [cell addSubview:aliasLabel];
            
            UILabel *consumLabel = [UILabel new];
            if ([self.viewModel.listType isEqualToString:@"anchor"]) {
                // 主播魅力值
                consumLabel.text = [NSString stringWithFormat:@"魅力值%@",model.score];
            } else if ([self.viewModel.listType isEqualToString:@"localTyrant"]) {
                // 土豪消费值
                consumLabel.text = [NSString stringWithFormat:@"消费%@万",model.score];
            } else {
                // 用户活跃值
                consumLabel.text = [NSString stringWithFormat:@"活跃值%@",model.score];
            }
            consumLabel.textAlignment = NSTextAlignmentCenter;
            consumLabel.font = SYRegularFont(15);
            consumLabel.textColor = SYColorFromHexString(@"#999999");
            [cell addSubview:consumLabel];
            
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor clearColor];
            [cell addSubview:bgView];
            [cell bringSubviewToFront:bgView];
            UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
            [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
                SYRankListModel *model = self.viewModel.dataSource[i];
                [self.viewModel.enterFriendDetailInfoCommand execute:model.userId];
            }];
            [bgView addGestureRecognizer:tapGesture];
            
            [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.width.offset(80.f);
                    make.height.offset(105.f);
                    make.centerX.equalTo(cell);
                    make.top.equalTo(cell).offset(15.f);
                } else if (i == 1) {
                    make.width.offset(50.f);
                    make.height.offset(70.f);
                    make.top.equalTo(cell).offset(50.f);
                    make.left.equalTo(cell).offset(itemMargin);
                } else {
                    make.width.offset(50.f);
                    make.height.offset(70.f);
                    make.top.equalTo(cell).offset(50.f);
                    make.right.equalTo(cell).offset(-itemMargin);
                }
            }];
            [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(backImageView.mas_width).offset(-10.f);
                make.center.equalTo(backImageView);
            }];
            [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backImageView.mas_bottom).offset(10);
                make.centerX.equalTo(backImageView);
                make.width.offset(SY_SCREEN_WIDTH / 3);
                make.height.offset(15);
            }];
            [consumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(aliasLabel.mas_bottom).offset(5);
                make.width.height.centerX.equalTo(aliasLabel);
            }];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backImageView);
                make.bottom.left.right.equalTo(consumLabel);
            }];
        }
    } else {
        UILabel *orderNum = [UILabel new];
        orderNum.text = [NSString stringWithFormat:@"%ld", indexPath.row + 3];
        [cell addSubview:orderNum];
        
        SYRankListModel *model = self.viewModel.dataSource[indexPath.row + 2];
        UIImageView *headImageView = [UIImageView new];
        [headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        headImageView.layer.cornerRadius = 20.f;
        headImageView.layer.masksToBounds = YES;
        [cell addSubview:headImageView];
        
        UILabel *aliasLabel = [UILabel new];
        aliasLabel.text = model.userName;
        aliasLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:aliasLabel];
        
        UILabel *customLabel = [UILabel new];
        if ([self.viewModel.listType isEqualToString:@"anchor"]) {
            // 主播魅力值
            customLabel.text = [NSString stringWithFormat:@"魅力值%@",model.score];
        } else if ([self.viewModel.listType isEqualToString:@"localTyrant"]) {
            // 土豪消费值
            customLabel.text = [NSString stringWithFormat:@"消费%@万",model.score];
        } else {
            // 用户活跃值
            customLabel.text = [NSString stringWithFormat:@"活跃值%@",model.score];
        }
        customLabel.textColor = SYColorFromHexString(@"#999999");
        [cell addSubview:customLabel];
        
        [orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(15);
            make.width.offset(20);
            make.top.height.equalTo(cell);
        }];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(40);
            make.centerY.equalTo(cell);
            make.left.equalTo(orderNum.mas_right).offset(15);
        }];
        [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(15.f);
            make.top.height.equalTo(cell);
            make.right.equalTo(customLabel.mas_left);
        }];
        [customLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.width.offset(100);
            make.height.top.equalTo(cell);
        }];
    }
    UIImageView *line = [UIImageView new];
    line.backgroundColor = SYColorFromHexString(@"#999999");
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(cell);
        make.height.offset(1);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 170.f;
    }
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        SYRankListModel *model = self.viewModel.dataSource[indexPath.row + 2];
        [self.viewModel.enterFriendDetailInfoCommand execute:model.userId];
    }
}

@end
