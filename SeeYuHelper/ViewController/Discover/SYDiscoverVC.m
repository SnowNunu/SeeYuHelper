//
//  SYDiscoverVC.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYDiscoverVC.h"
#import "SYMomentVC.h"
#import "SYPrivacyVC.h"
#import "SYForumVC.h"
#import "SYWebVC.h"
#import "SYWebVM.h"

@interface SYDiscoverVC ()

@property (nonatomic, readonly, strong) SYDiscoverVM *viewModel;

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYDiscoverVC

@dynamic viewModel;

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /// 设置导航栏
    [self _setupNavigation];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 80, 44) titles:@[@"动态",@"私密",@"问答",@"游戏"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.titleSelectColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    self.navigationItem.titleView = self.titleView;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    SYMomentVC *momentVC = [[SYMomentVC alloc] initWithViewModel:self.viewModel.momentVM];
    [childVCs addObject:momentVC];
    // 私密
    SYPrivacyVC *privacyVC = [[SYPrivacyVC alloc] initWithViewModel:self.viewModel.privacyVM];
    [childVCs addObject:privacyVC];
    // 问答
    SYForumVC *forumVC = [[SYForumVC alloc] initWithViewModel:self.viewModel.forumVM];
    [childVCs addObject:forumVC];
    // 游戏
    CYWebViewController *webVC = [[CYWebViewController alloc] init];
    webVC.url = [NSURL URLWithString:SY_GAME_URL];
    webVC.loadingBarTintColor = SYColor(159, 105, 235);
    webVC.showCustomView = YES;
    [childVCs addObject:webVC];
    
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SY_APPLICATION_TOP_BAR_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

@end
