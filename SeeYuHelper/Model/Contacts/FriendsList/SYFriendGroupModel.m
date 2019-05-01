//
//  SYFriendGroupModel.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendGroupModel.h"
#import "PinYinForObjc.h"
#import "SYFriendModel.h"

@implementation SYFriendGroupModel

+ (instancetype)getGroupsWithArray:(NSMutableArray*)friendsArray groupTitle:(NSString*)title {
    NSMutableArray *tempArray = [NSMutableArray array];
    SYFriendGroupModel *group = [[SYFriendGroupModel alloc] init];
    for (NSDictionary *dict in friendsArray) {
        SYFriendModel *friendModel = [[SYFriendModel alloc] init];
        friendModel.userFriendId = dict[@"userFriendId"];
        friendModel.userFriendName = dict[@"userFriendName"];
        friendModel.userHeadImg = dict[@"userHeadImg"];
        [tempArray addObject:friendModel];
    }
    group.groupTitle = title;
    group.friends = tempArray;
    return group;
}

@end
