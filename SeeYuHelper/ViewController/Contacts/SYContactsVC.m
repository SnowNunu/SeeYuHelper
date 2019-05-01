//
//  SYContactsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYContactsVC.h"
#import "SYChattingVC.h"
#import "SYFriendsListVM.h"
#import "SYFriendsListVC.h"

@interface SYContactsVC ()

/// viewModel
@property (nonatomic, readonly, strong) SYContactsVM *viewModel;

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYContactsVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置导航栏
    [self _setupNavigation];
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.viewModel.services.client.currentUser.userId;
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_PUSH_REBOT parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    [[self.viewModel.services.client enqueueRequest:request resultClass:[SYUser class]] subscribeCompleted:^{
        NSLog(@"推送成功");
    }];
    [self testWebSocket];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation{
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 80, 44) titles:@[@"聊天",@"好友"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.titleSelectColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    self.navigationItem.titleView = self.titleView;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    SYChattingVC *chattingVC = [SYChattingVC new];
    [childVCs addObject:chattingVC];
    SYFriendsListVM *friendsVM = [[SYFriendsListVM alloc] initWithServices:self.viewModel.services params:nil];
    SYFriendsListVC *friendsVC = [[SYFriendsListVC alloc]initWithViewModel:friendsVM];
    [childVCs addObject:friendsVC];
    
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, SY_APPLICATION_TOP_BAR_HEIGHT, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    self.contentView.contentViewCanScroll = NO;
    [self.view addSubview:_contentView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"btn_addFriend" target:nil selector:nil textType:NO];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.enterAddFriendsCommand;
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

- (void)testWebSocket {
    [[SYSocketManager shareManager] sy_open:@"ws://192.168.31.23:8088/ws" connect:^{
        [[SYSocketManager shareManager] sy_send:@"fuck you!"];
    } receive:^(id  _Nonnull message, SYSocketReceiveType type) {
        NSLog(@"%@",message);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
