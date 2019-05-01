//
//  NSDate+Extension.h
//  YBJY
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 YouBeiJiaYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+Extension.h"

#define SY_D_MINUTE	    60
#define SY_D_HOUR		3600
#define SY_D_DAY		86400
#define SY_D_WEEK		604800
#define SY_D_YEAR		31556926


@interface NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)sy_isToday;
/**
 *  是否为昨天
 */
- (BOOL)sy_isYesterday;
/**
 *  是否为今年
 */
- (BOOL)sy_isThisYear;
/**
 *  是否本周
 */
- (BOOL) sy_isThisWeek;

/**
 *  星期几
 */
- (NSString *)sy_weekDay;

/**
 *  是否为在相同的周
 */
- (BOOL) sy_isSameWeekWithAnotherDate: (NSDate *)anotherDate;


/**
 *  通过一个时间 固定的时间字符串 "2016/8/10 14:43:45" 返回时间
 *  @param timestamp 固定的时间字符串 "2016/8/10 14:43:45"
 */
+ (instancetype)sy_dateWithTimestamp:(NSString *)timestamp;

/**
 *  返回固定的 当前时间 2016-8-10 14:43:45
 */
+ (NSString *)sy_currentTimestamp;

/**
 *  返回当前时间的年份
 */
+ (NSString *)sy_currentYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)sy_dateWithYMD;

/**
 * 格式化日期描述
 */
- (NSString *)sy_formattedDateDescription;

/** 与当前时间的差距 */
- (NSDateComponents *)sy_deltaWithNow;



//////////// MVC&MVVM的商品的发布时间的描述 ////////////
- (NSString *)sy_string_yyyy_MM_dd;
- (NSString *)sy_string_yyyy_MM_dd:(NSDate *)toDate;
//////////// MVC&MVVM的商品的发布时间的描述 ////////////

@end
