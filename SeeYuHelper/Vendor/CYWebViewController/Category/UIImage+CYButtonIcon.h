//
//  UIImage+CYButtonIcon.h
//  CYWebviewController
//
//  Created by 万鸿恩 on 16/5/31.
//  Copyright © 2016年 万鸿恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CYButtonIcon)

/* Navigation Buttons */

/**
 *  creat back button icon
 *
 *  @return UIImage
 */
+ (id)cy_backButtonIcon:(UIColor*)color;

/**
 *  creat forward button icon
 *
 *  @return UIImage
 */
+ (id)cy_forwardButtonIcon:(UIColor*)color;


/**
 *  creat refresh button icon
 *
 *  @return UIImage
 */
+ (id)cy_refreshButtonIcon:(UIColor*)color;


/**
 *  creat stop button icon
 *
 *  @return UIImage
 */
+ (id)cy_stopButtonIcon:(UIColor*)color;

/**
 *  creat action button icon
 *
 *  @return UIImage
 */
+ (id)cy_actionButtonIcon:(UIColor*)color;

@end
