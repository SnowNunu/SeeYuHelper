//
//  SYUserIdentityAuth.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserIdentityAuth : SYObject

/** 主键 */
@property (nonatomic, assign) int identityId;

/** 用户id */
@property (nonatomic, assign) int identityUserid;

/** 用户真实姓名 */
@property (nonatomic, strong) NSString *identityRealname;

/** 身份证号 */
@property (nonatomic, strong) NSString *identityIdcardNum;

/** 身份证正面照片 */
@property (nonatomic, strong) NSString *identityIdFront;

/** 身份证背面照片 */
@property (nonatomic, strong) NSString *identityIdBehind;

/** 手持身份证照片 */
@property (nonatomic, strong) NSString *identityIdWithUser;

/** 0-未上传 1-审核中 2-审核失败 3-审核通过 */
@property (nonatomic, assign) int identityFlag;

/** 入库时间 */
@property (nonatomic, strong) NSDate *identityDate;

/** 审核时间 */
@property (nonatomic, strong) NSDate *identityAuditDate;

@end

NS_ASSUME_NONNULL_END
