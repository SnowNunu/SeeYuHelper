//
//  SYRechargeVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYRechargeVC.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "SYVipVC.h"
#import "SYCoinVC.h"

@interface SYRechargeVC () <FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupNavigation];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self changeFirstShowView];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 80, 44) titles:@[@"充值VIP",@"充值聊豆"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.titleSelectColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    self.navigationItem.titleView = self.titleView;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    // 充值vip界面
    SYVipVC *vipVC = [[SYVipVC alloc] initWithViewModel:self.viewModel.vipViewModel];
    [childVCs addObject:vipVC];
    // 充值聊豆界面
    SYCoinVC *coinVC = [[SYCoinVC alloc] initWithViewModel:self.viewModel.coinViewModel];
    [childVCs addObject:coinVC];
    
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

- (void)changeFirstShowView {
    if ([self.viewModel.rechargeType isEqualToString:@"coin"]) {
        self.titleView.selectIndex = 1;
        self.contentView.contentViewCurrentIndex = 1;
    } else {
        self.titleView.selectIndex = 0;
        self.contentView.contentViewCurrentIndex = 0;
    }
}

@end
