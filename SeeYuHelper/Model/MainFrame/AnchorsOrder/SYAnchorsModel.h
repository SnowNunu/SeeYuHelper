//
//  SYAnchorsModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsModel : SYObject

/* 主播id */
@property (nonatomic, strong) NSString *userId;

/* 主播昵称 */
@property (nonatomic, strong) NSString *userName;

/* 主播星级 */
@property (nonatomic, assign) int anchorStarLevel;

/* 主播签名 */
@property (nonatomic, strong) NSString *userSignature;

/* 主播爱好标签 */
@property (nonatomic, strong) NSString *userSpecialty;

/* 主播语聊价格 */
@property (nonatomic, strong) NSString *anchorChatCost;

/* 主播年龄 */
@property (nonatomic, strong) NSString *userAge;

/* 主播展示大图 */
@property (nonatomic, strong) NSString *showPhoto;

/* 主播展示视频 */
@property (nonatomic, strong) NSString *showVideo;

/* 主播展示头像 */
@property (nonatomic, strong) NSString *userHeadImg;

/* 主播在线状态 */
@property (nonatomic, assign) int userOnline;

@end

NS_ASSUME_NONNULL_END
