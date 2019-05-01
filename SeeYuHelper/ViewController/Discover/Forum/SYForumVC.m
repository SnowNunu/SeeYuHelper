//
//  SYForumVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumVC.h"
#import "SYForumListCell.h"
#import "SYForumModel.h"
#import "UIScrollView+SYRefresh.h"

@interface SYForumVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYForumVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestForumsCommand execute:@1];
            }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    @weakify(self)
    [[RACObserve(self.viewModel, datasource) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SYForumListCell class] forCellReuseIdentifier:@"forumListCell"];
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
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
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestForumsCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.pageNum = 1;
         [self.tableView.mj_footer resetNoMoreData];
     } error:^(NSError *error) {
         @strongify(self)
         [self.tableView.mj_header endRefreshing];
     } completed:^{
         @strongify(self)
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer resetNoMoreData];
     }];
}

#pragma mark - 上拉刷新事件
- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestForumsCommand execute:@(self.viewModel.pageNum + 1)] deliverOnMainThread] subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.pageNum += 1;
     } error:^(NSError *error) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
     } completed:^{
         @strongify(self)
         [self.tableView.mj_footer endRefreshing];
         [self.tableView.mj_footer endRefreshingWithNoMoreData];
     }];
}

#pragma  mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    SYForumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SYForumListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forumListCell"];
    }
    SYForumModel *model = self.viewModel.datasource[indexPath.row];
    cell.titleLabel.text = model.forumTitle;
    cell.contentLabel.text = model.forumContent;
    cell.commentsNumLabel.text = model.counts;
    if (model.forumPhoto != nil && model.forumPhoto.length > 0) {
        [cell setTitleImageViewByUrl:model.forumPhoto];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYForumModel *model = self.viewModel.datasource[indexPath.row];
    NSDictionary *params = @{SYViewModelUtilKey:[model yy_modelToJSONObject]};
    [self.viewModel.enterForumsDetailViewCommand execute:params];
}

@end
