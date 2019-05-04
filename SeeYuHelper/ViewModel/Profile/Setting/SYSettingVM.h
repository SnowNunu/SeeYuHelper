//
//  SYSettingVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAboutVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSettingVM : SYVM

@property (nonatomic, strong) RACCommand *enterAboutViewCommand;

@end

NS_ASSUME_NONNULL_END
