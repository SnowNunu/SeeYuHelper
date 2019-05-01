//
//  SYNearbyVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYNearbyVC.h"
#import "UIScrollView+SYRefresh.h"

@interface SYNearbyVC ()

@property (nonatomic, readwrite, strong) SYNearbyVM *viewModel;

@end

@implementation SYNearbyVC

@dynamic viewModel;

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithViewModel:(SYNearbyVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestNearbyFriendsCommand execute:@1];
            }];
        }
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
    // 获取用户地理位置
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;   //最佳精度
    [self startLocating];   // 开启定位
    [self _setupSubViews];
}

#pragma mark - 开始定位
- (void)startLocating {
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];   //开始定位
}

/* 定位完成后 回调 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    [manager stopUpdatingLocation];   //停止定位
    CLGeocoder *geoCoder = [CLGeocoder new];
    @weakify(self)
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        @strongify(self)
        CLPlacemark *pl = [placemarks firstObject];
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            
            NSLog(@"%@", pl.locality);
            self.city = pl.locality;
            [self.tableView reloadData];
        }
    }];
}

/* 定位失败后 回调 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错
        [MBProgressHUD sy_showTips:@"定位失败，请检查"];
    }
}
/* 监听用户授权状态 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 用户未开启定位功能
    }
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
        [self tableViewDidTriggerHeaderRefresh];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    /// 上拉加载
    [self.tableView sy_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        /// 加载上拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerFooterRefresh];
    }];
    if (@available(iOS 11.0, *)) {
        /// CoderMikeHe: 适配 iPhone X + iOS 11，
        SYAdjustsScrollViewInsets_Never(tableView);
        /// iOS 11上发生tableView顶部有留白，原因是代码中只实现了heightForHeaderInSection方法，而没有实现viewForHeaderInSection方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS 11之前是没有问题的，iOS 11之后应该是由于开启了估算行高机制引起了bug。
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsMake(SY_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestNearbyFriendsCommand
       execute:@1]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.pageNum = 1;
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
         [self _requestDataCompleted];
     }];
}
#pragma mark - 上拉刷新事件
- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestNearbyFriendsCommand
       execute:@(self.viewModel.pageNum + 1)]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.pageNum += 1;
     } error:^(NSError *error) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
     } completed:^{
         @strongify(self)
         [self.tableView.mj_footer endRefreshing];
         /// 请求完成
         [self _requestDataCompleted];
     }];
}

#pragma mark - 辅助方法
- (void)_requestDataCompleted {
    NSUInteger count = self.viewModel.dataSource.count;
    /// CoderMikeHe Fixed: 这里必须要等到，底部控件结束刷新后，再来设置无更多数据，否则被叠加无效
    if (count%self.viewModel.pageSize) [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    SYUser *user = self.viewModel.dataSource[indexPath.row];
    // 头像
    UIImageView *headImageView = [UIImageView new];
    [headImageView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
    headImageView.layer.cornerRadius = 35.f;
    headImageView.layer.borderColor = SYColorFromHexString(@"#F1F1F1").CGColor;
    headImageView.layer.borderWidth = 1.f;
    headImageView.layer.masksToBounds = YES;
    [cell addSubview:headImageView];
    
    // 昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.font = SYRegularFont(17);
    aliasLabel.text = user.userName;
    [cell addSubview:aliasLabel];
    
    // vip状态
    UIImageView *vipImageView = [UIImageView new];
    if (user.userVipStatus == 1) {
        // 再判断是否已过期
        NSTimeInterval seconds = [user.userVipExpiresAt timeIntervalSinceDate:[NSDate new]];//间隔的秒数
        if (seconds > 0) {
            vipImageView.hidden = NO;
        } else {
            vipImageView.hidden = YES;
        }
    } else {
        vipImageView.hidden = YES;
    }
    vipImageView.image = SYImageNamed(@"VIP");
    [cell addSubview:vipImageView];
    
    // 个性签名
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.font = SYRegularFont(15);
    signatureLabel.text = user.userSignature;
    [cell addSubview:signatureLabel];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.font = SYRegularFont(15);
    detailLabel.textColor = SYColor(99, 99, 99);
    NSString *detailLabelText = [NSString stringWithFormat:@"%@岁 · %@ %.1f公里外", user.userAge,_city,user.userDistance];
    detailLabel.text = detailLabelText;
    [cell addSubview:detailLabel];
    
    // 底部下划线
    UIImageView *line = [UIImageView new];
    line.backgroundColor = SYColor(99, 99, 99);
    [cell addSubview:line];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cell).offset(15);
        make.width.height.offset(70);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(15);
        make.height.offset(17);
        make.width.offset(120);
        make.top.equalTo(headImageView);
    }];
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(20);
        make.centerY.equalTo(aliasLabel);
        make.left.equalTo(aliasLabel.mas_right);
    }];
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aliasLabel);
        make.height.offset(14);
        make.top.equalTo(aliasLabel.mas_bottom).offset(15);
        make.right.equalTo(cell.mas_right).offset(-15);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(signatureLabel);
        make.top.equalTo(signatureLabel.mas_bottom).offset(12.5f);
        make.height.offset(12.5f);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(cell);
        make.height.offset(1);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYUser *user = self.viewModel.dataSource[indexPath.row];
    [self.viewModel.enterFriendDetailCommand execute:user.userId];
}

@end
