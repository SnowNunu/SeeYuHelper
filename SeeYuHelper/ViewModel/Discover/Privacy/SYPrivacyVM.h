//
//  SYPrivacyVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYPrivacyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPrivacyVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestPrivacyCommand;

@property (nonatomic, strong) RACCommand *enterPrivacyShowViewCommand;

@end

NS_ASSUME_NONNULL_END
