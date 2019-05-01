//
//  SYMomentsModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMomentsModel : SYObject

@property (nonatomic, strong) NSString *momentId;

@property (nonatomic, strong) NSString *momentUserid;

@property (nonatomic, strong) NSString *momentContent;

@property (nonatomic, strong) NSString *momentPhotos;

@property (nonatomic, strong) NSString *momentVideo;

@property (nonatomic, strong) NSString *momentTime;

@property (nonatomic, strong) NSString *momentPosition;

@property (nonatomic, strong) NSString *momentCanSee;

@property (nonatomic, strong) NSString *momentRemind;

@property (nonatomic, strong) NSString *momentStatus;

@property (nonatomic, strong) NSString *momentLiked;

@property (nonatomic, strong) NSString *userHeadImg;

@property (nonatomic, strong) NSString *userName;

@end

NS_ASSUME_NONNULL_END
