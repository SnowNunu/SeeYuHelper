//
//  MHAssetGroupViewController.h
//  HZWebBrowser
//
//  Created by 马浩 on 2017/9/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIScrollView+MHMH.h"
@interface MHAssetGroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _firstTime;
}
@property(nonatomic,strong)UITableView * tableview;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;

@end


@interface MHAssetGroupViewCell : UITableViewCell

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
