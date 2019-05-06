//
//  SYPaymentsVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/6.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPaymentsVC.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "SYPaymentsDetailVM.h"
#import "SYPaymentsDetailVC.h"

@interface SYPaymentsVC () <FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYPaymentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSecondTag];
}

#pragma mark - 设置二级标题
- (void)_setupSecondTag {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 40) titles:@[@"收入",@"提现"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = SYColor(153, 153, 153);
    self.titleView.titleSelectColor = SYColor(159, 105, 235);
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    [self.view addSubview:_titleView];
    
    UIImageView *line = [UIImageView new];
    line.backgroundColor = SYColorFromHexString(@"#E0E0E0");
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.height.offset(1);
        make.top.equalTo(self.titleView.mas_bottom).offset(-1);
    }];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (int i = 0; i < 2; i++) {
        SYPaymentsDetailVM *detailVM = [[SYPaymentsDetailVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelIDKey:[NSString stringWithFormat:@"%d",i+1]}];
        SYPaymentsDetailVC *detailVC = [[SYPaymentsDetailVC alloc] initWithViewModel:detailVM];
        [childVCs addObject:detailVC];
    }
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - 40 - SY_APPLICATION_TAB_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

@end
