//
//  SYCommonCell.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYCommonCell.h"
#import "SYCommonArrowItemViewModel.h"
#import "SYCommonAvatarItemViewModel.h"
#import "SYCommonQRCodeItemViewModel.h"
#import "SYCommonLabelItemViewModel.h"
#import "SYCommonSwitchItemViewModel.h"
@interface SYCommonCell ()
/// viewModel
@property (nonatomic, readwrite, strong) SYCommonItemViewModel *viewModel;

/// 箭头
@property (nonatomic, readwrite, strong) UIImageView *rightArrow;
/// 开关
@property (nonatomic, readwrite, strong) UISwitch *rightSwitch;
/// 标签
@property (nonatomic, readwrite, strong) UILabel *rightLabel;
/// avatar 头像
@property (nonatomic, readwrite, weak) UIImageView *avatarView;
/// QrCode
@property (nonatomic, readwrite, weak) UIImageView *qrCodeView;

/// 三条分割线
@property (nonatomic, readwrite, weak) UIImageView *divider0;
@property (nonatomic, readwrite, weak) UIImageView *divider1;
@property (nonatomic, readwrite, weak) UIImageView *divider2;

/// 中间偏左 view
@property (nonatomic, readwrite, weak) UIImageView *centerLeftView;
/// 中间偏右 view
@property (nonatomic, readwrite, weak) UIImageView *centerRightView;
@end


@implementation SYCommonCell

#pragma mark - 公共方法
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [self cellWithTableView:tableView style:UITableViewCellStyleValue1];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"CommonCell";
    SYCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows {
    self.divider0.hidden = NO;
    self.divider1.hidden = NO;
    self.divider2.hidden = NO;
    if (rows == 1) {                      /// 一段
        self.divider1.hidden = YES;
    }else if(indexPath.row == 0) {        /// 首行
        self.divider2.hidden = YES;
    }else if(indexPath.row == rows-1) {   /// 末行
        self.divider1.hidden = YES;
        self.divider0.hidden = YES;
    }else{ /// 中间行
        self.divider1.hidden = NO;
        self.divider0.hidden = YES;
        self.divider2.hidden = YES;
    }
}


- (void)bindViewModel:(SYCommonItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    self.avatarView.hidden = YES;
    self.qrCodeView.hidden = YES;
    
    self.selectionStyle = viewModel.selectionStyle;
    self.textLabel.text = viewModel.title;
    self.imageView.image = (SYStringIsNotEmpty(viewModel.icon))?SYImageNamed(viewModel.icon):nil;
    self.detailTextLabel.text = viewModel.subtitle;
    if (viewModel.subTitleColor) {
        self.detailTextLabel.textColor = viewModel.subTitleColor;
    }
    
    /// 设置全新
    if (SYStringIsNotEmpty(viewModel.centerLeftViewName)) {
        self.centerLeftView.hidden = NO;
        self.centerLeftView.image = SYImageNamed(viewModel.centerLeftViewName);
        self.centerLeftView.sy_size = self.centerLeftView.image.size;
    }else{
        self.centerLeftView.hidden = YES;;
    }
    
    /// 设置锁
    if (SYStringIsNotEmpty(viewModel.centerRightViewName)) {
        self.centerRightView.hidden = NO;
        self.centerRightView.image = SYImageNamed(viewModel.centerRightViewName);
        self.centerRightView.sy_size = self.centerRightView.image.size;
    } else {
        self.centerRightView.hidden = YES;;
    }

    if ([viewModel isKindOfClass:[SYCommonArrowItemViewModel class]]) {  /// 纯带箭头
        self.accessoryView = self.rightArrow;
        if ([viewModel isKindOfClass:[SYCommonAvatarItemViewModel class]]) { // 头像
            SYCommonAvatarItemViewModel *avatarViewModel = (SYCommonAvatarItemViewModel *)viewModel;
            self.avatarView.hidden = NO;
            [self.avatarView yy_setImageWithURL:[NSURL URLWithString:avatarViewModel.avatar] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }else if ([viewModel isKindOfClass:[SYCommonQRCodeItemViewModel class]]){ // 二维码
            self.qrCodeView.hidden = NO;
        }
    }else if([viewModel isKindOfClass:[SYCommonSwitchItemViewModel class]]){ /// 开关
        // 右边显示开关
        SYCommonSwitchItemViewModel *switchViewModel = (SYCommonSwitchItemViewModel *)viewModel;
        self.accessoryView = self.rightSwitch;
        self.rightSwitch.on = !switchViewModel.off;
    }else{
        self.accessoryView = nil;
    }
}
#pragma mark - 私有方法
- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化
- (void)_setup{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = SYColorFromHexString(@"#888888");
    self.detailTextLabel.numberOfLines = 0;
    self.textLabel.font = SYRegularFont_17;
    self.detailTextLabel.font = SYRegularFont_16;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    
    /// CoderMikeHe Fixed : 这里需要把divider添加到self，而不是self.contentView ,由于添加了 accessView，导致self.contentView的宽度<self的宽度
    // 分割线
    UIImageView *divider0 = [[UIImageView alloc] init];
    self.divider0 = divider0;
    [self addSubview:divider0];
    UIImageView *divider1 = [[UIImageView alloc] init];
    self.divider1 = divider1;
    [self addSubview:divider1];
    UIImageView *divider2 = [[UIImageView alloc] init];
    self.divider2 = divider2;
    [self addSubview:divider2];
    divider0.backgroundColor = divider1.backgroundColor = divider2.backgroundColor = SY_MAIN_LINE_COLOR_1;
    
    /// 添加用户头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    self.avatarView = avatarView;
    avatarView.hidden = YES;
    [self.contentView addSubview:avatarView];
    /// 设置圆角+线宽
    [avatarView zy_attachBorderWidth:1.0f color:SYColorFromHexString(@"#BFBFBF")];
    [avatarView zy_cornerRadiusAdvance:25.0f rectCornerType:UIRectCornerAllCorners];
    
    /// 二维码照片
    UIImageView *qrCodeView = [[UIImageView alloc] initWithImage:SYImageNamed(@"setting_myQR_18x18")];
    qrCodeView.hidden = YES;
    self.qrCodeView = qrCodeView;
    [self.contentView addSubview:qrCodeView];
    
    /// 中间偏左的图片
    UIImageView *centerLeftView = [[UIImageView alloc] init];
    centerLeftView.hidden = YES;
    self.centerLeftView = centerLeftView;
    [self.contentView addSubview:centerLeftView];
    
    /// 中间偏左的图片
    UIImageView *centerRightView = [[UIImageView alloc] init];
    centerRightView.hidden = YES;
    self.centerRightView = centerRightView;
    [self.contentView addSubview:centerRightView];
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    /// 设置
    if ((fabs(self.textLabel.sy_x - self.detailTextLabel.sy_x) <=.1f)) {
        /// SubTitle
        self.textLabel.sy_bottom = self.detailTextLabel.sy_top;
    }else{
        self.textLabel.sy_centerY = self.sy_height * .5f;
    }
    
    
    self.divider0.frame = CGRectMake(0, 0, self.sy_width, SYGlobalBottomLineHeight);
    self.divider1.frame = CGRectMake(14, self.sy_height-SYGlobalBottomLineHeight, self.sy_width-14, SYGlobalBottomLineHeight);
    self.divider2.frame = CGRectMake(0, self.sy_height-SYGlobalBottomLineHeight, self.sy_width, SYGlobalBottomLineHeight);
    
    /// 设置头像
    self.avatarView.sy_size = CGSizeMake(50, 50);
    self.avatarView.sy_right = self.accessoryView.sy_left - 7;
    self.avatarView.sy_centerY = self.sy_height * .5f;
    
    /// 设置二维码
    self.qrCodeView.sy_right = self.accessoryView.sy_left - 11;
    self.qrCodeView.sy_centerY = self.sy_height * .5f;
    
    /// 配置Artboard
    self.centerLeftView.sy_left = self.textLabel.sy_right + 14;
    self.centerLeftView.sy_centerY = self.sy_height * .5f;
    
    /// 配置
    self.centerRightView.sy_right = self.detailTextLabel.sy_left - 5;
    self.centerRightView.sy_centerY = self.sy_height * .5f;
}

#pragma mark - 事件处理
- (void)_switchValueDidiChanged:(UISwitch *)sender{
    SYCommonSwitchItemViewModel *switchViewModel = (SYCommonSwitchItemViewModel *)self.viewModel;
    switchViewModel.off = !sender.isOn;
}



#pragma mark - Setter Or Getter
- (UIImageView *)rightArrow{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc] initWithImage:SYImageNamed(@"tableview_arrow")];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch{
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch addTarget:self action:@selector(_switchValueDidiChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

@end
