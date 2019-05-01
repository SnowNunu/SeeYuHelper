//
//  MHAssetPickerViewController.m
//  HZWebBrowser
//
//  Created by 马浩 on 2017/9/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "MHAssetPickerViewController.h"
#import "MHAssetGroupViewController.h"

@interface MHAssetPickerViewController ()

@end

@implementation MHAssetPickerViewController
-(id)init
{
    MHAssetGroupViewController *groupViewController = [[MHAssetGroupViewController alloc] init];
    if (self = [super initWithRootViewController:groupViewController]) {
        _assetPickType = MHAssetPickTypeALL;
        _selectionFilter = [NSPredicate predicateWithValue:YES];
        _maxSelecteNum = 1;
        _curentSelectedNum = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.barTintColor = HexRGBAlpha(0x34aeff, 1) ;
//    self.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    self.navigationBar.translucent = YES;
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
