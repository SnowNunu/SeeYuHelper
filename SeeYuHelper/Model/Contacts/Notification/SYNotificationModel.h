//
//  SYNotificationModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYNotificationModel : SYObject

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *senderId;
@end

NS_ASSUME_NONNULL_END
