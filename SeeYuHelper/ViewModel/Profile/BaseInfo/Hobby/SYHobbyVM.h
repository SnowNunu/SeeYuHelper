//
//  SYHobbyVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYHobbyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYHobbyVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestHobbiesCommand;

@property (nonatomic, copy) void (^hobbyBlock)(NSString *hobby);

@end

NS_ASSUME_NONNULL_END
