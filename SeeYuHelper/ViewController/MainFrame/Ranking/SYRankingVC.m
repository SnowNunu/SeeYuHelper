//
//  SYRankingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYRankingVC.h"
#import "SYRankingVM.h"

@interface SYRankingVC ()

@property (nonatomic, strong) SYRankingVM *viewModel;

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYRankingVC

@dynamic viewModel;

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupNavigation];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 40) titles:@[@"主播",@"土豪",@"活跃"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = SYColorFromHexString(@"#999999");
    self.titleView.titleSelectColor = SYColor(159, 105, 235);
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    [self.view addSubview:_titleView];
    
    NSArray *typeArray = @[@"anchor",@"localTyrant",@"active"];
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (int i = 0; i < typeArray.count; i++) {
        SYRankListVM *listViewModel = [[SYRankListVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:typeArray[i]}];
        SYRankListVC *rankListVC = [[SYRankListVC alloc] initWithViewModel:listViewModel];
        [childVCs addObject:rankListVC];
    }
    
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40.f, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - 40 - SY_APPLICATION_TAB_BAR_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
    self.title = @[@"主播",@"土豪",@"活跃"][endIndex];
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
    self.title = @[@"主播",@"土豪",@"活跃"][endIndex];
}

@end
