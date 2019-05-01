//
//  SYCollocationVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYCollocationVM.h"
#import "SYSpeedMatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollocationVC : SYVC

@property (nonatomic, strong) SYCollocationVM *viewModel;

@property (nonatomic, strong) SYSpeedMatchModel *matchModel;

@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) NSString *page;

@end

NS_ASSUME_NONNULL_END
