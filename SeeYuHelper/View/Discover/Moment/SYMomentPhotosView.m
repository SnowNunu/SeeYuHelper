//
//  SYMomentPhotosView.m
//  SYDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMomentPhotosView.h"
#import "SYMomentPhotoView.h"
#import "SYMomentsModel.h"
#import "YYPhotoGroupView.h"

@interface SYMomentPhotosView ()

/// viewModel
@property (nonatomic, readwrite, strong) SYMomentsModel *viewModel;

@end

@implementation SYMomentPhotosView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 预先创建9个图片控件 避免动态创建
        for (int i = 0; i < SYMomentPhotosMaxCount; i++) {
            SYMomentPhotoView *photoView = [[SYMomentPhotoView alloc] init];
            photoView.backgroundColor = self.backgroundColor;
            photoView.hidden = YES;
            photoView.tag = i;
            [self addSubview:photoView];
            
            // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(_tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
        }
    }
    return self;
}


///// bind data
//- (void)bindViewModel:(SYMomentsModel *)viewModel {
//    self.viewModel = viewModel;
//    CGFloat photoViewWH = SYMomentPhotosViewItemWidth();
//
//    /// 设置显示or隐藏以及布局
//    NSUInteger count = viewModel.momentPhotos.count;
//
//    if (count==0) [self _hideAllImageViews];
//
//    int maxCols = SYMomentMaxCols(count);
//    for (int i = 0; i < SYMomentPhotosMaxCount; i++) {
//        SYMomentPhotoView *photoView = self.subviews[i];
//        if (i < count) {
//            /// 显示隐藏
//            photoView.hidden = NO;
//            if(count == 1) {   /// 一张图的情况
//                photoView.frame = self.bounds;
//            } else {
//                /// 其他情况
//                photoView.sy_width = photoViewWH;
//                photoView.sy_height = photoViewWH;
//                photoView.sy_x = (i % maxCols) * (photoViewWH + SYMomentPhotosViewItemInnerMargin);
//                photoView.sy_y = (i / maxCols) * (photoViewWH + SYMomentPhotosViewItemInnerMargin);
//            }
//            // 绑定数据
//            [photoView bindViewModel:viewModel.momentPhotos[i]];
//        } else {
//            // 隐藏
//            /// 这里我重写了子控件的 hidden方法 目的是取消 图片下载请求
//            photoView.hidden = YES;
//        }
//    }
//
//}

/// 隐藏所有图片
- (void)_hideAllImageViews {
    for (SYMomentPhotoView *imageView in self.subviews) {
        imageView.hidden = YES;
    }
}

#pragma mark - 事件处理
- (void)_tapPhoto:(UITapGestureRecognizer *)sender {
    /// 图片浏览
//    NSMutableArray *items = [NSMutableArray new];
//    CGFloat count = self.viewModel.momentPhotos.count;
//    for (NSUInteger i = 0; i < count; i++) {
//        UIView *imgView = self.subviews[i];
//        SYPicture *picture = [self.viewModel.momentPhotos[i] picture];
//        SYPictureMetadata *meta = picture.largest.badgeType == SYPictureBadgeTypeGIF ? picture.largest : picture.large;
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = imgView;
//        item.largeImageURL = meta.url;
//        item.largeImageSize = CGSizeMake(meta.width, meta.height);
//        [items addObject:item];
//    }
//    /// 关闭popView
//    [SYMomentHelper hideAllPopViewWithAnimated:YES];
//    YYPhotoGroupView *photoBrowser = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [photoBrowser presentFromImageView:sender.view toContainer:self.window animated:YES completion:NULL];
}


@end
