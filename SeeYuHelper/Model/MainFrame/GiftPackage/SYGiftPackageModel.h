//
//  SYGiftPackageModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftPackageModel : SYObject

/* 主键 */
@property (nonatomic, assign) int giftRecordId;

/* 第N天 */
@property (nonatomic, assign) int giftRecordDay;

/* 第N天 */
@property (nonatomic, assign) int day;

/* 数量 */
@property (nonatomic, assign) int giftRecordNum;

/* 类型 */
@property (nonatomic, assign) int giftRecordType;

/* 礼包配置时间 */
@property (nonatomic, strong) NSString *giftRecordDate;

/* 礼物id */
@property (nonatomic, assign) int giftRecordGiftid;

/* 礼物价格 */
@property (nonatomic, assign) int giftRecordGiftPrice;

/* 是否签到过 */
@property (nonatomic, assign) int giftRecordIsReceive;

/* 礼物名称 */
@property (nonatomic, strong) NSString *giftRecordGiftName;

/* 礼物收取时间 */
@property (nonatomic, strong) NSString *giftRecordReceiveDate;

/* 用户id */
@property (nonatomic, strong) NSString *giftRecordUserid;

/* 礼物图片url */
@property (nonatomic, strong) NSString *giftRecordGiftUrl;

@end

NS_ASSUME_NONNULL_END
