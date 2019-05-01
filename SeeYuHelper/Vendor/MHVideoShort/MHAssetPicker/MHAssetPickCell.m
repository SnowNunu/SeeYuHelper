//
//  MHAssetPickCell.m
//  HZWebBrowser
//
//  Created by 马浩 on 2017/9/26.
//  Copyright © 2017年 HuZhang. All rights reserved.
//

#import "MHAssetPickCell.h"

@interface MHAssetPickCell ()
{
    UIImageView * _thumbImg;//缩略图
    UILabel * _videoLengthLab;//视频长度
    UIImageView * _selectedIcon;//选中图标
}
@end
@implementation MHAssetPickCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _thumbImg = [[UIImageView alloc] initWithFrame:self.bounds];
        _thumbImg.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImg.clipsToBounds = YES;
        [self.contentView addSubview:_thumbImg];
        
        _videoLengthLab = [[UILabel alloc] initWithFrame:CGRectMake(4, self.bounds.size.height-15, self.bounds.size.width-8, 15)];
        _videoLengthLab.textColor = [UIColor whiteColor];
        _videoLengthLab.textAlignment = NSTextAlignmentLeft;
        _videoLengthLab.font = [UIFont systemFontOfSize:12];
        _videoLengthLab.hidden = YES;
        [self.contentView addSubview:_videoLengthLab];
        
        _selectedIcon = [[UIImageView alloc] init];
        _selectedIcon.frame = CGRectMake(self.bounds.size.width-24-5, 5, 24, 24);
        [self.contentView addSubview:_selectedIcon];
    }
    return self;
}
-(void)setModel:(MHAssetModel *)model
{
    _model = model;
    _thumbImg.image = [UIImage imageWithCGImage:model.asset.aspectRatioThumbnail];
    
    if ([[model.asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        _videoLengthLab.hidden=NO;
        _videoLengthLab.text=[NSDate timeDescriptionOfTimeInterval:[[model.asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    } else{
        _videoLengthLab.hidden=YES;
    }
    
    if (model.isChooseOne) {//只选一张
        _selectedIcon.hidden = YES;
    }else{//可多选
        _selectedIcon.hidden = NO;
        if (model.isSelected) {
            _selectedIcon.image = [UIImage imageNamed:@"public_pic_choose"];
        }else{
            _selectedIcon.image = [UIImage imageNamed:@"public_pic_nochoose"];
        }
    }
    
//    if ([model.selectionFilter evaluateWithObject:model.asset]) {
//
//    }else{
//
//    }
}
@end


@implementation MHAssetModel

@end

@implementation NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.hour * 60) - (components.minute * 60 * 60));
    
    if (components.hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
    }
}
@end
