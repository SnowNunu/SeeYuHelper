//
//  SYForumListCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYForumListCell : UITableViewCell

@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UIImageView *commentImageView;

@property (nonatomic, strong) UILabel *commentsNumLabel;

@property (nonatomic, strong) UILabel *toAnswerLabel;

- (void)setTitleImageViewByUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
