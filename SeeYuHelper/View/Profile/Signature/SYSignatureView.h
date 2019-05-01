//
//  SYSignatureView.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSignatureView : UIView

+ (instancetype)signatureTextView;

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, weak) UIImageView *divider0;

@property (nonatomic, weak) UIImageView *divider1;

@property (nonatomic, weak) UILabel *wordsLabel;

@end

NS_ASSUME_NONNULL_END
