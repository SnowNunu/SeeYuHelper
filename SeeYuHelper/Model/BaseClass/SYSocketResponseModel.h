//
//  SYSocketResponseModel.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/2.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"
#import "SYSocketResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSocketResponseModel : SYObject

@property (nonatomic, assign) int code;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
