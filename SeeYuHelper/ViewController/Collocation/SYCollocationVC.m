//
//  SYCollocationVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationVC.h"
#import "JPVideoPlayerKit.h"

@interface SYCollocationVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *singleShowView;

@property (nonatomic, strong) UIScrollView *controlView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *unlikeBtn;

@property (nonatomic, assign) NSString *direction;

@end

@implementation SYCollocationVC

- (NSMutableArray *)datasource {
    if (_datasource == nil) {
        _datasource = [NSMutableArray new];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self reloadCacheData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.singleShowView.jp_playerStatus == JPVideoPlayerStatusStop) {
        [self.singleShowView jp_resumePlayWithURL:[NSURL URLWithString:self.matchModel.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.singleShowView jp_stopPlay];
}

- (void)bindViewModel {
    [RACObserve(self.viewModel, speedMatchList) subscribeNext:^(NSArray *array) {
        if (array != nil) {
            if (array.count == 0) {
                // 此时服务器中没有更多的数据了，重置页码为0
                YYCache *cache = [YYCache cacheWithName:@"seeyu"];
                [cache setObject:@"1" forKey:@"speedMatchPage"];
                self.page = @"1";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.viewModel.requestSpeedMatchCommand execute:@"1"];
                });
            } else {
                // 从服务器上拉取到的新数据
                self.datasource = [NSMutableArray arrayWithArray:array];
                YYCache *cache = [YYCache cacheWithName:@"seeyu"];
                [cache setObject:self.datasource forKey:@"speedMatch"];
                [self startUserShow];
            }
        }
    }];
    [[self.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
        [self changeUser];
    }];
    [[self.unlikeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self changeUser];
    }];
}

- (void)_setupSubViews {
    UIView *singleShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT)];
    _singleShowView = singleShowView;
    [self.view addSubview:singleShowView];
    
    UIScrollView *controlView = [UIScrollView new];
    controlView.delegate = self;
    controlView.contentSize = CGSizeMake(SY_SCREEN_WIDTH * 2, 0);
    _controlView = controlView;
    [self.view addSubview:controlView];
    [self.view bringSubviewToFront:controlView];
    
    UIButton *unlikeBtn = [UIButton new];
    [unlikeBtn setImage:SYImageNamed(@"btn_unlike") forState:UIControlStateNormal];
    _unlikeBtn = unlikeBtn;
    [controlView addSubview:unlikeBtn];
    
    UIButton *likeBtn = [UIButton new];
    [likeBtn setImage:SYImageNamed(@"btn_like") forState:UIControlStateNormal];
    _likeBtn = likeBtn;
    [controlView addSubview:likeBtn];
    
    CGFloat margin = (SY_SCREEN_WIDTH - 200) / 3;
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(singleShowView);
    }];
    [unlikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.bottom.equalTo(singleShowView).offset(-30);
        make.left.equalTo(singleShowView).offset(margin);
    }];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(unlikeBtn);
        make.right.equalTo(singleShowView).offset(-margin);
    }];
}

// 加载缓存数据
- (void)reloadCacheData {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
//    [cache removeObjectForKey:@"speedMatch"];
//    [cache removeObjectForKey:@"speedMatchPage"];
    if ([cache containsObjectForKey:@"speedMatch"]) {
        // 有缓存数据优先读取缓存数据
        id dataValue = [cache objectForKey:@"speedMatch"];
        self.datasource = (NSMutableArray*)dataValue;
        id pageValue = [cache objectForKey:@"speedMatchPage"];
        NSString *page = (NSString*)pageValue;
        if (self.datasource.count <= 0) {
            page = [NSString stringWithFormat:@"%d",[page intValue] + 1];
            [self.viewModel.requestSpeedMatchCommand execute:page];
            [cache setObject:page forKey:@"speedMatchPage"];
        } else {
            [self startUserShow];
        }
        self.page = page;
    } else {
        // 初次使用没有缓存数据
        if ([cache containsObjectForKey:@"speedMatchPage"]) {
            // 读取页码
            id pageValue = [cache objectForKey:@"speedMatchPage"];
            self.page = (NSString*)pageValue;
            [self.viewModel.requestSpeedMatchCommand execute:self.page];
        } else {
            // 设置页码页面为1
            [cache setObject:@"1" forKey:@"speedMatchPage"];
            self.page = @"1";
            [self.viewModel.requestSpeedMatchCommand execute:self.page];
        }
    }
}

// 读取数组元素播放展示页
- (void)startUserShow {
    self.matchModel = self.datasource[0];
    [self.singleShowView jp_playVideoWithURL:[NSURL URLWithString:self.matchModel.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
    
    }];
}

// 切换用户
- (void)changeUser {
    if (self.datasource.count > 1) {
        [self.datasource removeObjectAtIndex:0];
        [self.singleShowView jp_stopPlay];
        self.matchModel = self.datasource[0];
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        [cache setObject:self.datasource forKey:@"speedMatch"];
        [self.singleShowView jp_playVideoWithURL:[NSURL URLWithString:self.matchModel.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        
        }];
    } else {
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        self.page = [NSString stringWithFormat:@"%d",self.page.intValue + 1];
        [cache setObject:self.page forKey:@"speedMatchPage"];
        [self.viewModel.requestSpeedMatchCommand execute:self.page];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    if(translatedPoint.x < 0) {
        _direction = @"left";
    } else {
        _direction = @"right";
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_direction isEqualToString:@"right"]) {
        [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
    }
    [self changeUser];
}

@end
