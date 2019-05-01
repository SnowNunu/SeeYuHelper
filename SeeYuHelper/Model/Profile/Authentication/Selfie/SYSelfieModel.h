//
//  SYSelfieModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSelfieModel : SYObject

@property (nonatomic, strong) NSString *searchValue;

@property (nonatomic, strong) NSString *createBy;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *updateBy;

@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *params;

@property (nonatomic, strong) NSString *selfieId;

@property (nonatomic, strong) NSString *selfieUserid;

@property (nonatomic, strong) NSString *selfiePhoto;

@property (nonatomic, strong) NSString *selfieVideo;

@property (nonatomic, strong) NSString *selfieDate;

@property (nonatomic, strong) NSString *selfieFlag;

@property (nonatomic, strong) NSString *selfieAuditDate;

@end

NS_ASSUME_NONNULL_END
