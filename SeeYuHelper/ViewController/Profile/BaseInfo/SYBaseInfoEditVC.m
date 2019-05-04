//
//  SYBaseInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYBaseInfoEditVC.h"

@interface SYBaseInfoEditVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic, strong) ZYImagePicker *imagePicker;

@end

@implementation SYBaseInfoEditVC

- (ZYImagePicker *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[ZYImagePicker alloc]init];
        _imagePicker.resizableClipArea = NO;
        _imagePicker.clipSize = CGSizeMake(SY_SCREEN_WIDTH - 60, SY_SCREEN_WIDTH - 60);
        _imagePicker.slideColor = [UIColor whiteColor];
        _imagePicker.slideWidth = 4;
        _imagePicker.slideLength = 40;
        _imagePicker.didSelectedImageBlock = ^BOOL(UIImage *selectedImage) {
            return YES;
        };
    }
    return _imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"头像",@"kind":@"image"},@{@"label":@"昵称",@"kind":@"text"},@{@"label":@"个性签名",@"kind":@"text"},@{@"label":@"爱好",@"kind":@"text"},@{@"label":@"封面图片",@"kind":@"text"},@{@"label":@"封面视频",@"kind":@"text"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user != nil) {
            [self.tableView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.separatorInset = UIEdgeInsetsZero;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *params = _dataSource[indexPath.row];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = SYColor(51, 51, 51);
    titleLabel.font = SYRegularFont(16);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = params[@"label"];
    [cell.contentView addSubview:titleLabel];
    
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = 15.f;
    avatarImageView.image = SYImageNamed(@"DefaultProfileHead_66x66");
    [cell.contentView addSubview:avatarImageView];
    if (![params[@"kind"] isEqualToString:@"image"]) {
        avatarImageView.hidden = YES;
    }
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = SYColor(153, 153, 153);
    contentLabel.font = SYRegularFont(12);
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    [cell.contentView addSubview:contentLabel];
    if ([params[@"kind"] isEqualToString:@"image"]) {
        contentLabel.hidden = YES;
    }
    
    UIImageView *arrowImageView = [UIImageView new];
    arrowImageView.image = SYImageNamed(@"detail_back");
    [cell.contentView addSubview:arrowImageView];
    if ([params[@"kind"] isEqualToString:@"label"]) {
        arrowImageView.hidden = YES;
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.width.offset(70);
    }];
    if ([params[@"kind"] isEqualToString:@"image"]) {
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-10);
            make.width.height.offset(30);
            make.centerY.equalTo(cell.contentView);
        }];
    } else {
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-10);
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(titleLabel.mas_right).offset(10);
        }];
    }
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(7);
        make.height.offset(14);
    }];
    if (indexPath.row == 0) {
        if (self.viewModel.user.userHeadImg != nil && self.viewModel.user.userHeadImg.length > 0) {
            [avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }
    } else if (indexPath.row == 1) {
        if (self.viewModel.user.userName != nil && self.viewModel.user.userName.length > 0) {
            contentLabel.text = self.viewModel.user.userName;
        }
    } else if (indexPath.row == 2) {
        if (self.viewModel.user.userSignature != nil && self.viewModel.user.userSignature.length > 0) {
            contentLabel.text = self.viewModel.user.userSignature;
        }
    } else if (indexPath.row == 3) {
        if (self.viewModel.user.userSpecialty != nil && self.viewModel.user.userSpecialty.length > 0) {
            contentLabel.text = self.viewModel.user.userSpecialty;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        @weakify(self)
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            @strongify(self)
            __weak typeof(self) weakSelf = self;
            if (buttonIndex == 0) return ;
            if (buttonIndex == 1) {
                // 拍照
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_camera;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    [weakSelf.viewModel.uploadAvatarImageCommand execute:[clippedImage resetSizeOfImageData:clippedImage maxSize:300]];
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            } else {
                // 相册
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    [weakSelf.viewModel.uploadAvatarImageCommand execute:[clippedImage resetSizeOfImageData:clippedImage maxSize:300]];
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            }
        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet show];
    } else if (indexPath.row == 1) {
        // 修改昵称
        NSString *value = SYStringIsNotEmpty(self.viewModel.user.userName) ? self.viewModel.user.userName : @"";
        SYNicknameModifyVM *viewModel = [[SYNicknameModifyVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:value}];
        viewModel.callback = ^(NSString *text) {
            [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userName":text}];
        };
        [self.viewModel.services presentViewModel:viewModel animated:YES completion:NULL];
    } else if (indexPath.row == 2) {
        // 修改签名
        NSString *value = SYStringIsNotEmpty(self.viewModel.user.userSignature) ? self.viewModel.user.userSignature : @"";
        SYSignatureVM *viewModel = [[SYSignatureVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:value}];
        viewModel.callback = ^(NSString *text) {
            [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userSignature":text}];
        };
        [self.viewModel.services presentViewModel:viewModel animated:YES completion:NULL];
    } else if (indexPath.row == 3) {
        // 选择爱好
        [self.viewModel.enterHobbyChooseViewCommand execute:nil];
    } else if (indexPath.row == 4) {
        // 上传封面
        [self.viewModel.enterUploadCoverViewCommand execute:nil];
    } else {
        // 上传视频
        [self.viewModel.enterModifyVideoViewCommand execute:nil];
    }
}

@end
