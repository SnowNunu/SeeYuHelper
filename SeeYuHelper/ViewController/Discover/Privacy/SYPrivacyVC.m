//
//  SYPrivacyVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyVC.h"

@interface SYPrivacyVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SYPrivacyVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestPrivacyCommand execute:nil];
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
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            [self.collectionView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SY_SCREEN_WIDTH - 45) / 2;
    layout.itemSize = CGSizeMake(width, width * 0.8);
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"privacyViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView = collectionView;
    [self.view addSubview:collectionView];
}

- (void)_makeSubViewsConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
// 分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 每个分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYPrivacyModel *model = self.viewModel.datasource[indexPath.row];
    static NSString *cellIndentifer = @"privacyViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    // 展示图片
    UIImageView *photoShowView = [UIImageView new];
    [photoShowView yy_setImageWithURL:[NSURL URLWithString:model.showPhoto] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    [cell.contentView addSubview:photoShowView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurEffectView.frame = cell.contentView.bounds;
//    if (indexPath.row > 4) {
//        [photoShowView addSubview:blurEffectView];
//    }

    // 播放图标
    UIImageView *playImageView = [UIImageView new];
    playImageView.image = SYImageNamed(@"new_icon_video_play");
    [photoShowView addSubview:playImageView];
    //底部背景
    UIImageView *shadowImageView = [UIImageView new];
    shadowImageView.image = SYImageNamed(@"shadow_bottom");
    [photoShowView addSubview:shadowImageView];
    
    // 昵称文本
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.text = model.userName;
    aliasLabel.font =SYRegularFont(16);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    [shadowImageView addSubview:aliasLabel];
    
    [photoShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(photoShowView);
        make.width.height.offset(30);
    }];
    [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell.contentView);
        make.height.offset(35);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shadowImageView).offset(10);
        make.width.equalTo(shadowImageView);
        make.bottom.equalTo(shadowImageView).offset(-10);
        make.height.offset(15);
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYPrivacyModel *model = self.viewModel.datasource[indexPath.row];
    NSDictionary *params = @{SYViewModelUtilKey:[model yy_modelToJSONObject]};
    [self.viewModel.enterPrivacyShowViewCommand execute:params];
}

@end
