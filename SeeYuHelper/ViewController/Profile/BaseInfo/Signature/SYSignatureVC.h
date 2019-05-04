//
//  SYSignatureVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYSignatureVM.h"
#import "SYSignatureView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSignatureVC : SYVC

@property (nonatomic, strong) SYSignatureVM *viewModel;

@property (nonatomic, strong) SYSignatureView *signatureView;

@end

NS_ASSUME_NONNULL_END
