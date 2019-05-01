//
//  SYPrivacyShowVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYPrivacyModel.h"
#import "SYPrivacyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPrivacyShowVM : SYVM

@property (nonatomic, strong) SYPrivacyModel *model;
//
//@property (nonatomic, strong) SYPrivacyDetailModel *detailModel;

/* 返回 */
@property (nonatomic, strong) RACCommand *goBackCommand;

/* 获取关注和好友状态 */
@property (nonatomic, strong) RACCommand *requestPrivacyStateCommand;

/* 私密视频点赞 */
@property (nonatomic, strong) RACCommand *privacyVideoLikedCommand;

/* 发起好友请求 */
@property (nonatomic, strong) RACCommand *sendAddFriendsRequestCommand;

@end

NS_ASSUME_NONNULL_END
