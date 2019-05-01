//
//  SYForumCommentModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumCommentModel : SYObject

@property (nonatomic, strong) NSString* userId;

@property (nonatomic, strong) NSString* userHeadImg;

@property (nonatomic, strong) NSString* userName;

@property (nonatomic, strong) NSString* userGender;

@property (nonatomic, strong) NSString* commentId;

@property (nonatomic, strong) NSString* commentContent;

@property (nonatomic, strong) NSString* commentDate;

@property (nonatomic, strong) NSString* commentLiked;

@property (nonatomic, strong) NSString *likedStatus;

@end

NS_ASSUME_NONNULL_END
