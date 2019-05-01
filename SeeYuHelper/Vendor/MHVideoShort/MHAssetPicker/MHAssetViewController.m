//
//  MHAssetViewController.m
//  HZWebBrowser
//
//  Created by 马浩 on 2017/9/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "MHAssetViewController.h"
#import "MHAssetPickerViewController.h"
#import "MHAssetPickCell.h"

static CGFloat minimumInteritemSpacing = 5.0;
static CGFloat minimumLineSpacing = 5.0;

@interface MHAssetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _maxSelectedNum;//最多可选数量
    NSInteger _canSelectedNum;//当前可选数量
    BOOL _chooseOne;//是否是只选一张
}
@property(nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *assets;
@property(nonatomic,strong)NSMutableArray * selectedAssets;//选中的asset
@end

@implementation MHAssetViewController
-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.assets = [NSMutableArray arrayWithCapacity:0];
    self.selectedAssets = [NSMutableArray arrayWithCapacity:0];
    [self updateNavRightItem];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((self.view.bounds.size.width-25)/4, (self.view.bounds.size.width-25)/4);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MHAssetPickCell class] forCellWithReuseIdentifier:@"MHAssetViewControllerMHAssetViewController"];
    [self.view addSubview:self.collectionView];
    
    [self setupAssets];
}
- (void)setupAssets
{
    MHAssetPickerViewController *picker = (MHAssetPickerViewController *)self.navigationController;
    _maxSelectedNum = picker.maxSelecteNum;
    _canSelectedNum = picker.maxSelecteNum - picker.curentSelectedNum;
    if (_canSelectedNum <= 0) {
        _canSelectedNum = 0;
    }
    if (_maxSelectedNum == 1) {
        _chooseOne = YES;
    }
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            //            if ([picker.selectionFilter evaluateWithObject:asset]) {
            MHAssetModel * model = [[MHAssetModel alloc] init];
            model.isChooseOne = _chooseOne;
            model.isSelected = NO;
            model.asset = asset;
            model.selectionFilter = picker.selectionFilter;
            [self.assets addObject:model];
        } else if (self.assets.count > 0) {
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.assets.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHAssetPickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHAssetViewControllerMHAssetViewController" forIndexPath:indexPath];
    MHAssetModel * model = (MHAssetModel *)self.assets[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHAssetModel * model = (MHAssetModel *)self.assets[indexPath.row];
    if (_chooseOne) {//单选模式-直接代理-退出
        [self.selectedAssets addObject:model.asset];
        [self finishenItemSelected];
    }else{
        
        if (model.isSelected) {//取消选中
            _canSelectedNum += 1;
            [self.selectedAssets removeObject:model.asset];
        }else{//添加选中
            if (_canSelectedNum == 0) {
                NSLog(@"最多选4张图     这里可能需要tips");
                return;
            }else{
                _canSelectedNum -= 1;
                [self.selectedAssets addObject:model.asset];
            }
        }
        model.isSelected = !model.isSelected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self updateNavRightItem];
    }
}
-(void)updateNavRightItem
{
    if (self.selectedAssets.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishenItemSelected)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleItemSelceted)];
    }
}
#pragma mark - 完成
-(void)finishenItemSelected
{
    [UIScrollView mh_scrollOpenAdjustment:NO];
    MHAssetPickerViewController *picker = (MHAssetPickerViewController *)self.navigationController;
    if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)]) {
        [picker.delegate assetPickerController:picker didFinishPickingAssets:self.selectedAssets];
    }
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - 取消
- (void)cancleItemSelceted
{
    [UIScrollView mh_scrollOpenAdjustment:NO];
    MHAssetPickerViewController *picker = (MHAssetPickerViewController *)self.navigationController;
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
