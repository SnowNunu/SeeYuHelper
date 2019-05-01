//
//  SYForumCommentCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYForumCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headPhotoView;

@property (nonatomic, strong) YYLabel *aliasLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UILabel *likeNumLabel;

@end

NS_ASSUME_NONNULL_END
