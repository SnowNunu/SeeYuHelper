//
//  MHAssetPickerViewController.h
//  HZWebBrowser
//
//  Created by 马浩 on 2017/9/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIScrollView+MHMH.h"

typedef NS_ENUM(NSInteger , MHAssetPickType) {
    MHAssetPickTypeImage,//图片
    MHAssetPickTypeVideo,//视频
    MHAssetPickTypeALL,//图片+视频
};

@protocol MHAssetPickerControllerDelegate;

@interface MHAssetPickerViewController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, MHAssetPickerControllerDelegate> delegate;
@property (nonatomic, assign) MHAssetPickType assetPickType;//选取类型
@property (nonatomic, strong) NSPredicate *selectionFilter;//过滤
@property(nonatomic,assign)NSInteger maxSelecteNum;//最多选取数量
@property(nonatomic,assign)NSInteger curentSelectedNum;//当前已选数量

@end

@protocol MHAssetPickerControllerDelegate <NSObject>

@optional
-(void)assetPickerController:(MHAssetPickerViewController *)picker didFinishPickingAssets:(NSArray *)assets;
-(void)assetPickerController:(MHAssetPickerViewController *)picker didFinishPickingVideo:(NSURL *)videoUrl;

@end
