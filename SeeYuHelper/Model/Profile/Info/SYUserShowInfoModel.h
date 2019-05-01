//
//  SYUserShowInfoModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserShowInfoModel : SYObject

@property (nonatomic, strong) NSString *showUserid;

@property (nonatomic, strong) NSString *showPhoto;

@property (nonatomic, strong) NSString *showVideo;

@property (nonatomic, strong) NSString *showPhotoStatus;

@property (nonatomic, strong) NSString *showVideoStatus;

@property (nonatomic, strong) NSString *showPhotoDate;

@property (nonatomic, strong) NSString *showVideoDate;

@end

NS_ASSUME_NONNULL_END
