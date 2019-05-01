//
//  SYPresentVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPresentVC.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "SYPresentListVM.h"
#import "SYPresentListVC.h"

@interface SYPresentVC () <FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYPresentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSecondTag];
}

#pragma mark - 设置二级标题
- (void)_setupSecondTag {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 40) titles:@[@"我收到的",@"我送出的"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = SYColorFromHexString(@"#999999");
    self.titleView.titleSelectColor = SYColor(159, 105, 235);
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    [self.view addSubview:_titleView];
    
    NSArray *typeArray = @[@"receive",@"give"];
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (int i = 0; i < 2; i++) {
        SYPresentListVM *listViewModel = [[SYPresentListVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:typeArray[i]}];
        SYPresentListVC *presentsListVC = [[SYPresentListVC alloc] initWithViewModel:listViewModel];
        [childVCs addObject:presentsListVC];
    }
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - 40 - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

@end
