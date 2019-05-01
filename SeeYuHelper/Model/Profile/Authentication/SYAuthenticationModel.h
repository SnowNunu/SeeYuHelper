//
//  SYAuthenticationModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/4.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAuthenticationModel : SYObject

/* 手机认证状态：0-未绑定，1-已绑定 */
@property (nonatomic, assign) int mobileFlag;

/* 实名认证状态：0-未上传，1-审核中，2-审核失败，3-审核通过 */
@property (nonatomic, assign) int identityFlag;

/* 自拍认证状态：0-未上传，1-审核中，2-审核失败，3-审核通过 */
@property (nonatomic, assign) int selfieFlag;

@end

NS_ASSUME_NONNULL_END
