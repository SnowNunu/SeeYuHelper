//
//  SYForumResultModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumResultModel : SYObject

@property (nonatomic, strong) NSString *commentForumid;

@property (nonatomic, strong) NSString *commentUserid;

@property (nonatomic, strong) NSString *commentContent;

@property (nonatomic, strong) NSString *commentDate;

@property (nonatomic, strong) NSString *commentStatus;

@property (nonatomic, strong) NSString *commentLiked;

@property (nonatomic, strong) NSString *liked;

@end

NS_ASSUME_NONNULL_END
