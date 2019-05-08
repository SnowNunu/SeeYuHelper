//
//  SYGiftListVC.m
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/8.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftListVC.h"

@interface SYGiftListVC () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *giftsListLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UICollectionView *giftsCollectionView;

@end

static NSString *reuseIdentifier = @"giftListCellIdentifier";

@implementation SYGiftListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestGiftListInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(id x) {
        [self.giftsCollectionView reloadData];
    }];
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(255, 255, 255, 0.2);
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 15.f;
    bgView.layer.masksToBounds = YES;
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UILabel *giftsListLabel = [UILabel new];
    giftsListLabel.text = @"礼物列表";
    giftsListLabel.textAlignment = NSTextAlignmentLeft;
    giftsListLabel.font = [UIFont boldSystemFontOfSize:16];
    giftsListLabel.textColor = SYColor(159, 105, 235);
    _giftsListLabel = giftsListLabel;
    [bgView addSubview:giftsListLabel];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setBackgroundImage:SYImageNamed(@"close") forState:UIControlStateNormal];
    _closeBtn = closeBtn;
    [bgView addSubview:closeBtn];
    
    CGFloat margin = (SY_SCREEN_WIDTH - 30 - 60 - 50 * 4) / 3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 25; // 最小行间距
    layout.minimumInteritemSpacing = margin; // 最小左右间距
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.estimatedItemSize = CGSizeMake(50, 87.5);
    
    UICollectionView *giftsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    giftsCollectionView.delegate = self;
    giftsCollectionView.dataSource = self;
    giftsCollectionView.backgroundColor = [UIColor whiteColor];
    [giftsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _giftsCollectionView = giftsCollectionView;
    [bgView addSubview:giftsCollectionView];
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-45);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.giftsListLabel.mas_top).offset(-15);
    }];
    [_giftsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-20);
        make.left.equalTo(self.bgView).offset(30);
        make.right.equalTo(self.bgView).offset(-30);
        make.height.offset(200);
    }];
    [_giftsListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.giftsCollectionView.mas_top).offset(-30);
        make.height.offset(20);
        make.left.equalTo(self.bgView).offset(15);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.top.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
    }];
}

#pragma mark UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SYGiftListModel *model = self.viewModel.datasource[indexPath.row];
    
    UIImageView *giftImageView = [UIImageView new];
    [giftImageView yy_setImageWithURL:[NSURL URLWithString:model.giftImg] placeholder:SYImageNamed(@"message_icon_cucumber_gift") options:SYWebImageOptionAutomatic completion:NULL];
    [cell.contentView addSubview:giftImageView];
    
    UILabel *numberLabel = [UILabel new];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = SYColor(159, 105, 235);
    numberLabel.font = [UIFont boldSystemFontOfSize:10];
    NSString *number;
    if (model.totalNum == 0) {
        number = [NSString stringWithFormat:@"%d",model.totalNum];
    } else {
        number = [NSString stringWithFormat:@"x%d",model.totalNum];
    }
    numberLabel.text = number;
    [cell.contentView addSubview:numberLabel];
    
    UILabel *giftNameLabel = [UILabel new];
    giftNameLabel.textAlignment = NSTextAlignmentCenter;
    giftNameLabel.textColor = SYColor(153, 153, 153);
    giftNameLabel.font = [UIFont boldSystemFontOfSize:8];
    giftNameLabel.text = model.giftName;
    [cell.contentView addSubview:giftNameLabel];
    
    [giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40);
        make.top.equalTo(cell.contentView).offset(10);
        make.centerX.equalTo(cell.contentView);
    }];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giftImageView.mas_bottom).offset(6);
        make.height.offset(10);
        make.centerX.equalTo(cell.contentView);
    }];
    [giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.top.equalTo(numberLabel.mas_bottom).offset(6);
        make.height.offset(10);
    }];
    return cell;
}



@end
