//
//  SYPrivacyModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"
#import "SYPrivacyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPrivacyModel : SYObject

@property (nonatomic, strong) NSString *showId;

@property (nonatomic, strong) NSString *showUserid;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *showPhoto;

@property (nonatomic, strong) NSString *showVideo;

@property (nonatomic, strong) NSString *userHeadImg;

@property (nonatomic, strong) NSString *userSignature;

@property (nonatomic, strong) SYPrivacyDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
