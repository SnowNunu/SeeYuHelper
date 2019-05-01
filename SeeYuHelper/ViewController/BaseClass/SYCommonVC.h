//
//  SYCommonVC.h
//  SeeYu
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  用于快速搭建 类似 设置界面的样式

#import "SYTableVC.h"
#import "SYCommonVM.h"

@interface SYCommonVC : SYTableVC

@property (nonatomic, strong) SYCommonVM *viewModel;

@end
