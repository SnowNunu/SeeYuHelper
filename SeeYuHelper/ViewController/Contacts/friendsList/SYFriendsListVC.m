//
//  SYFriendsListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendsListVC.h"
#import "SYFriendsList.h"
#import "PinYinForObjc.h"
#import "SYFriendGroupModel.h"
#import "NSMutableArray+FilterElement.h"
#import "SYFriendsListCell.h"
#import "SYFriendModel.h"
#import "SYSearchFriendsResultVC.h"
#import "SYSearchResultHandle.h"
#import "SYSingleChattingVC.h"

@interface SYFriendsListVC () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView; // 好友列表视图

@property (nonatomic, strong) NSMutableArray *aliasArray; // 全部好友昵称

@property (nonatomic, strong) NSMutableArray *sectionIndexArray; // 存放字母索引的数组

@property (nonatomic, strong) NSMutableArray *array;    // 重新排序分组后的数据源数组

@property (nonatomic, strong) NSMutableArray *searchList; // 搜索结果的数组

@property (nonatomic, strong) UISearchController *searchFriendsVC;  // 好友搜索框

@property (nonatomic, strong) SYSearchFriendsResultVC *searchResultVC;  // 好友搜索结果

@end

@implementation SYFriendsListVC

#pragma mark 懒加载部分内容
- (NSMutableArray *)aliasArray {
    if (_aliasArray == nil) {
        _aliasArray = [NSMutableArray new];
    }
    return _aliasArray;
}

- (NSMutableArray *)sectionIndexArray {
    if (_sectionIndexArray == nil) {
        _sectionIndexArray = [NSMutableArray new];
    }
    return _sectionIndexArray;
}

- (instancetype)initWithViewModel:(SYFriendsListVM *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self _setupSearchVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.getFriendsListCommand execute:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.array removeAllObjects];
    [self.sectionIndexArray removeAllObjects];
}

- (void)bindViewModel {
    @weakify(self)
//    [RACObserve(self.viewModel, freshFriendCount) subscribeNext:^(NSString *count) {
//        NSLog(@"新的朋友数量：%d",[count intValue]);
//        if ([count intValue] > 0) {
//            SYFriendsListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SYFriendsListCell" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            cell.badgeView.badgeText = count;
//            [cell.badgeView setNeedsLayout];
//        }
//    }];
    [RACObserve(self.viewModel, userFriendsArray) subscribeNext:^(NSArray *friendsList) {
        if (friendsList.count > 1) {
            @strongify(self)
            for (NSDictionary *dict in friendsList) {
                [self.aliasArray addObject:dict[@"userFriendName"]];
            }
            for (NSString *string in self.aliasArray) {
                if (![string isEqualToString:@"红娘客服"]) {
                    NSString *header = [PinYinForObjc chineseConvertToPinYinHead:string];
                    [self.sectionIndexArray addObject:header];
                }
            }
            // 去除数组中相同的元素
            self.sectionIndexArray = [self.sectionIndexArray filterTheSameElement];
            // 数组排序
            [self.sectionIndexArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *string1 = obj1;
                NSString *string2 = obj2;
                return [string1 compare:string2];
            }];
            if ([self.sectionIndexArray[0] isEqualToString:@"#"]) {
                [self.sectionIndexArray replaceObjectAtIndex:0 withObject:@"☆"];
                [self.sectionIndexArray addObject:@"#"];
            } else {
                [self.sectionIndexArray insertObject:@"☆" atIndex:0];
            }
        } else {
            // 用户注册时默认添加红娘为好友
            if (friendsList.count == 0) {
                return;
            }
            [self.sectionIndexArray addObject:@"☆"];
        }
        // 目前已经获得所有的首字母，现在就是需要把全部数据按首字母排序
        NSMutableArray *friendsModelArray = [NSMutableArray new];
        for (NSString *string in self.sectionIndexArray) {
            NSMutableArray *tempArray = [NSMutableArray new];
            if ([string isEqualToString:@"☆"]) {
                [tempArray addObject:@{@"userFriendId": @"10000",@"userFriendName": @"新的朋友",@"userHeadImg":@"icon_newFriend"}];
                for (NSDictionary *dict in friendsList) {
                    if ([dict[@"userFriendName"] isEqualToString:@"红娘客服"]) {
                        [tempArray addObject:dict];
                    }
                }
            } else {
                for (NSDictionary *dict in friendsList) {
                    if ([[PinYinForObjc chineseConvertToPinYinHead:dict[@"userFriendName"]] isEqualToString:string]) {
                        if (![dict[@"userFriendName"] isEqualToString:@"红娘客服"]) {
                            [tempArray addObject:dict];
                        }
                    }
                }
            }
            SYFriendGroupModel *group = [SYFriendGroupModel getGroupsWithArray:tempArray groupTitle:string];
            [friendsModelArray addObject:group];
        }
        self.array = friendsModelArray;
        [self.tableView reloadData];
    }];
}

- (void)_setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.sectionIndexColor = [UIColor blackColor]; // 设置默认时索引值颜色
//    _tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor]; // 设置选中时，索引背景颜色
//    [_tableView registerClass:[SYFriendsListCell class] forCellReuseIdentifier:@"SYFriendsListCell"];
    [self.view addSubview:_tableView];
}

- (void)_setupSearchVC {
    _searchResultVC = [[SYSearchFriendsResultVC alloc] init];
//    self.searchResultVC.delegate = self;
    _searchFriendsVC = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
    _searchFriendsVC.delegate = self;
//    _searchController.delegateCustom = self;
    _searchFriendsVC.searchResultsUpdater = self;
    _searchFriendsVC.dimsBackgroundDuringPresentation = NO;
    _searchFriendsVC.hidesNavigationBarDuringPresentation = YES;
    _searchFriendsVC.searchBar.delegate = self;
    _searchFriendsVC.searchBar.frame = CGRectMake(0, 0, SY_SCREEN_WIDTH, 44);
    _searchFriendsVC.searchBar.placeholder = @"请输入搜索的的内容";
    _searchFriendsVC.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchFriendsVC.searchBar.returnKeyType = UIReturnKeyDone;
    _searchFriendsVC.searchBar.backgroundImage = [UIImage imageWithColor:SYColorFromHexString(@"#9F69EB") size:CGSizeMake(_searchFriendsVC.searchBar.width,44)];
    self.tableView.tableHeaderView = self.searchFriendsVC.searchBar;
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SY_APPLICATION_TAB_BAR_HEIGHT);
    }];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchFriendsVC.active ? 1 : self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchFriendsVC.active) {
        return 0;
    }
    SYFriendGroupModel *group = self.array[section];
    return group.friends.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SYFriendsListCell";
    SYFriendsListCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell) {
        cell = [[SYFriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    SYFriendGroupModel *group = self.array[indexPath.section];
    SYFriendModel *friendModel = group.friends[indexPath.row];
    cell.friendId = friendModel.userFriendId;
    cell.aliasLabel.text = friendModel.userFriendName;
    if ([friendModel.userFriendName isEqualToString:@"新的朋友"]) {
        cell.headImageView.image = SYImageNamed(@"icon_newFriend");
        if (self.viewModel.freshFriendCount > 0) {
            cell.badgeView.badgeText = [NSString stringWithFormat:@"%d",self.viewModel.freshFriendCount];
            [cell.badgeView setNeedsLayout];
        } else {
            cell.badgeView.badgeText = nil;
            [cell.badgeView setNeedsLayout];
        }
    } else if ([friendModel.userFriendName isEqualToString:@"红娘客服"]) {
        cell.headImageView.image = SYImageNamed(@"icon_cusService");
    } else {
        if ([friendModel.userHeadImg sy_isNullOrNil]) {
            cell.headImageView.image = SYImageNamed(@"header_default_100x100");
        } else {
            [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:friendModel.userHeadImg] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
        }
    }
    return cell;
}

// 右侧的索引标题数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.searchFriendsVC.active ? nil : self.sectionIndexArray;
}

// 返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SYFriendGroupModel *group = self.array[section];
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 42)];
    bgView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SY_SCREEN_WIDTH - 40, 42)];
    label.text = group.groupTitle;
    label.font = SYRegularFont(15);
    [bgView addSubview:label];
    return bgView;
}

// 设置表头的高度。如果使用自定义表头，该方法必须要实现，否则自定义表头无法执行，也不会报错
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchFriendsVC.active || section == 0) {
        return 0;
    } else {
        return 42;
    }
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYFriendGroupModel *group = self.array[indexPath.section];
    SYFriendModel *friendModel = group.friends[indexPath.row];
    if ([friendModel.userFriendName isEqualToString:@"新的朋友"]) {
        [self.viewModel.enterNewFriendsViewCommand execute:nil];
    } else {
        SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        NSNumber *friendId = (NSNumber*)friendModel.userFriendId;
        conversationVC.targetId = [friendId stringValue];
        conversationVC.title = friendModel.userFriendName;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchFriendsVC.searchBar text];
    // 移除搜索结果数组的数据
    [self.searchList removeAllObjects];
    //过滤数据
    self.searchList = [SYSearchResultHandle getSearchResultBySearchText:searchString dataArray:self.array];
    if (searchString.length == 0 && self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [self.searchList filterTheSameElement];
    NSMutableArray *dataSource = nil;
    if ([self.searchList count] > 0) {
        dataSource = [NSMutableArray array];
        // 结局了数据重复的问题
        for (NSString *str in self.searchList) {
            SYFriendModel *model = [[SYFriendModel alloc] init];
            model.userFriendName = str;
//            model.img_Url = nil;
            [dataSource addObject:model];
        }
    }
    //刷新表格
    self.searchResultVC.dataSource = dataSource;
    [self.searchResultVC.tableView reloadData];
    [self.tableView reloadData];
}

@end
