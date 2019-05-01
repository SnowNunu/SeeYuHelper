//
//  UIScrollView+MHMH.h
//  NHZGame
//
//  Created by 马浩 on 2017/10/20.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MHMH)


/**
 iOS 11 开启/关闭contentInsetAdjustmentBehavior

 @param open 开启/关闭contentInsetAdjustmentBehavior
 */
+(void)mh_scrollOpenAdjustment:(BOOL)open;

@end
