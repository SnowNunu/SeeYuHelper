//
//  SYForumModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumModel : SYObject

/* 帖子id */
@property (nonatomic, strong) NSString *forumId;

/* 帖子标题 */
@property (nonatomic, strong) NSString *forumTitle;

/* 帖子文本 */
@property (nonatomic, strong) NSString *forumContent;

/* 帖子图片 */
@property (nonatomic, strong) NSString *forumPhoto;

/* 帖子评论数 */
@property (nonatomic, strong) NSString *counts;




@end

NS_ASSUME_NONNULL_END
