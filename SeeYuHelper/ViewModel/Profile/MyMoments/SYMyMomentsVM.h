//
//  SYMyMomentsVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMyMomentsVM : SYVM

@property (nonatomic, strong) NSArray *yearArray;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *enterMomentsEditView;

@property (nonatomic, strong) RACCommand *requestAllMineMomentsCommand;

@end

NS_ASSUME_NONNULL_END
