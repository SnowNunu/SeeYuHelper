//
//  SYAnchorVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYAnchorVC.h"

@interface SYAnchorVC ()

@property (nonatomic, strong) SYAnchorVM *viewModel;

@end

@implementation SYAnchorVC

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithViewModel:(SYAnchorVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
        @weakify(self)
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(self)
            /// 请求第一页的网络数据
            [self.viewModel.requestAnchorsCommand execute:@1];
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
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    self.viewModel = [[SYAnchorVM alloc]init];
    self.viewModel.dataSource = @[@{@"userName":@"Mandora",@"userHeadImg":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548851597370&di=f51cb9811c5fe2c5dd90fe17cbf33b46&imgtype=0&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20140910%2Fxingganyouximeinvzhaopian_3014685.jpg"},@{@"userName":@"Jason",@"userHeadImg":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548851597368&di=a34bf008768d9e6760200026dd058441&imgtype=0&src=http%3A%2F%2Fpic31.nipic.com%2F20130703%2F7447430_131151146000_2.jpg"},@{@"userName":@"你的小萱萱",@"userHeadImg":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548851597368&di=61a3234cfba0c759b364c837d51c14a4&imgtype=0&src=http%3A%2F%2Fpic5.nipic.com%2F20100127%2F2177138_082501971985_2.jpg"},@{@"userName":@"干啥子呢",@"userHeadImg":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548851597366&di=2020cbf50cc0370a1afb7e6acd25fd28&imgtype=0&src=http%3A%2F%2Fk1.jsqq.net%2Fuploads%2Fallimg%2F160609%2F5_160609154717_1.jpg"},@{@"userName":@"你的波老师"},@{@"userName":@"水蜜桃3D"},@{@"userName":@"小雪碧"},@{@"userName":@"小柠檬"},@{@"userName":@"馨儿"},@{@"userName":@"偷人心的狐狸精"}];
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
        make.height.equalTo(self.view).offset(-SY_APPLICATION_TAB_BAR_HEIGHT);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // 添加下拉刷新控件
    @weakify(self);
    [self.tableView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerHeaderRefresh];
    }];
//    [self.tableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        /// CoderMikeHe: 适配 iPhone X + iOS 11，
        SYAdjustsScrollViewInsets_Never(tableView);
        /// iOS 11上发生tableView顶部有留白，原因是代码中只实现了heightForHeaderInSection方法，而没有实现viewForHeaderInSection方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS 11之前是没有问题的，iOS 11之后应该是由于开启了估算行高机制引起了bug。
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
}

#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestAnchorsCommand
       execute:@1]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         /// 重置没有更多的状态
         [self.tableView.mj_footer resetNoMoreData];
     } error:^(NSError *error) {
         @strongify(self)
         /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以reload = NO即可
         [self.tableView.mj_header endRefreshing];
     } completed:^{
         @strongify(self)
         /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以只要结束刷新即可
         [self.tableView.mj_header endRefreshing];
         /// 请求完成
     }];
//    [self.viewModel.requestAnchorsCommand ]
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
            UIImageView *headImageView = [UIImageView new];
            [headImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.dataSource[i][@"userHeadImg"]] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
            [cell addSubview:headImageView];
            
            UIImageView *backImageView = [UIImageView new];
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
            aliasLabel.text = self.viewModel.dataSource[i][@"userName"];
            aliasLabel.textAlignment = NSTextAlignmentCenter;
            aliasLabel.font = SYRegularFont(17);
            [cell addSubview:aliasLabel];
            
            UILabel *consumLabel = [UILabel new];
            consumLabel.text = [NSString stringWithFormat:@"魅力值%d万",50 - i];
            consumLabel.textAlignment = NSTextAlignmentCenter;
            consumLabel.font = SYRegularFont(15);
            consumLabel.textColor = SYColorFromHexString(@"#999999");
            [cell addSubview:consumLabel];
            
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
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        UILabel *orderNum = [UILabel new];
        orderNum.text = [NSString stringWithFormat:@"%ld", indexPath.row + 3];
        [cell addSubview:orderNum];
        
        UIImageView *headImageView = [UIImageView new];
        [headImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.dataSource[indexPath.row + 2][@"userHeadImg"]] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        headImageView.layer.cornerRadius = 20.f;
        headImageView.layer.masksToBounds = YES;
        [cell addSubview:headImageView];
        
        UILabel *aliasLabel = [UILabel new];
        aliasLabel.text = self.viewModel.dataSource[indexPath.row + 2][@"userName"];
        aliasLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:aliasLabel];
        
        UILabel *customLabel = [UILabel new];
        customLabel.text = [NSString stringWithFormat:@"魅力值%ld万",40 - indexPath.row * 3];
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 170.f;
    }
    return 50.f;
}

@end
