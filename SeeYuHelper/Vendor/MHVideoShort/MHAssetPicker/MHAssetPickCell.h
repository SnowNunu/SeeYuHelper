//
//  MHAssetPickCell.h
//  HZWebBrowser
//
//  Created by 马浩 on 2017/9/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@class MHAssetModel;

@interface MHAssetPickCell : UICollectionViewCell

@property(nonatomic,strong)MHAssetModel * model;

@end


@interface MHAssetModel : NSObject

@property (nonatomic, strong) ALAsset * asset;
@property(nonatomic,assign)NSInteger index;
@property (nonatomic, strong) NSPredicate *selectionFilter;
@property(nonatomic,assign)BOOL isChooseOne;//是否是单张选取模式
@property(nonatomic,assign)BOOL isSelected;

@end

@interface NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end
