//
//  UIFont+SYExtension.h
//  SYDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He 但是苹方字体 iOS9.0+出现  需要做适配
 *  这个分类主要用来 字体...
 (
 "PingFangSC-Ultralight",
 "PingFangSC-Regular",
 "PingFangSC-Semibold",
 "PingFangSC-Thin",
 "PingFangSC-Light",
 "PingFangSC-Medium"
 )
 */

// IOS版本
#define SYIOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])


/// 设置系统的字体大小（YES：粗体 NO：常规）
#define SYFont(__size__,__bold__) ((__bold__)?([UIFont boldSystemFontOfSize:__size__]):([UIFont systemFontOfSize:__size__]))

/// 极细体
#define SYUltralightFont(__size__) ((SYIOSVersion<9.0)?SYFont(__size__ , YES):[UIFont sy_fontForPingFangSC_UltralightFontOfSize:__size__])

/// 纤细体
#define SYThinFont(__size__)       ((SYIOSVersion<9.0)?SYFont(__size__ , YES):[UIFont sy_fontForPingFangSC_ThinFontOfSize:__size__])

/// 细体
#define SYLightFont(__size__)      ((SYIOSVersion<9.0)?SYFont(__size__ , YES):[UIFont sy_fontForPingFangSC_LightFontOfSize:__size__])

// 中等
#define SYMediumFont(__size__)     ((SYIOSVersion<9.0)?SYFont(__size__ , YES):[UIFont sy_fontForPingFangSC_MediumFontOfSize:__size__])

// 常规
#define SYRegularFont(__size__)    ((SYIOSVersion<9.0)?SYFont(__size__ , NO):[UIFont sy_fontForPingFangSC_RegularFontOfSize:__size__])

/** 中粗体 */
#define SYSemiboldFont(__size__)   ((SYIOSVersion<9.0)?SYFont(__size__ , YES):[UIFont sy_fontForPingFangSC_SemiboldFontOfSize:__size__])



/// 苹方常规字体 10
#define SYRegularFont_10 SYRegularFont(10.0f)
/// 苹方常规字体 11
#define SYRegularFont_11 SYRegularFont(11.0f)
/// 苹方常规字体 12
#define SYRegularFont_12 SYRegularFont(12.0f)
/// 苹方常规字体 13
#define SYRegularFont_13 SYRegularFont(13.0f)
/** 苹方常规字体 14 */
#define SYRegularFont_14 SYRegularFont(14.0f)
/// 苹方常规字体 15
#define SYRegularFont_15 SYRegularFont(15.0f)
/// 苹方常规字体 16
#define SYRegularFont_16 SYRegularFont(16.0f)
/// 苹方常规字体 17
#define SYRegularFont_17 SYRegularFont(17.0f)
/// 苹方常规字体 18
#define SYRegularFont_18 SYRegularFont(18.0f)
/// 苹方常规字体 19
#define SYRegularFont_19 SYRegularFont(19.0f)
/// 苹方常规字体 20
#define SYRegularFont_20 SYRegularFont(20.0f)


#import <UIKit/UIKit.h>

@interface UIFont (SYExtension)

/**
 *  苹方极细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) sy_fontForPingFangSC_UltralightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方常规体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) sy_fontForPingFangSC_RegularFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中粗体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) sy_fontForPingFangSC_SemiboldFontOfSize:(CGFloat)fontSize;

/**
 *  苹方纤细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) sy_fontForPingFangSC_ThinFontOfSize:(CGFloat)fontSize;

/**
 *  苹方细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) sy_fontForPingFangSC_LightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中黑体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) sy_fontForPingFangSC_MediumFontOfSize:(CGFloat)fontSize;




@end
