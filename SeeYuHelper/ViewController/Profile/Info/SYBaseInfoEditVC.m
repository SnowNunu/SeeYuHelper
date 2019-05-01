//
//  SYBaseInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYBaseInfoEditVC.h"

@interface SYBaseInfoEditVC () <UITableViewDelegate, UITableViewDataSource, ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic, strong) ZYImagePicker *imagePicker;

@property (nonatomic, strong) ActionSheetCustomPicker *customPicker;

@property (nonatomic, strong) NSString *options;    // 区分是地址还是生日选择

@property (nonatomic, strong) NSArray *addressArray; // 解析出来的最外层数组

@property (nonatomic, strong) NSArray *provinceArray; // 省

@property (nonatomic, strong) NSArray *countryArray; // 市

@property (nonatomic, strong) NSArray *birthdayArray; // 解析出来的最外层数组

@property (nonatomic, strong) NSArray *monthArray; // 月

@property (nonatomic, strong) NSArray *dayArray; // 日

@property (nonatomic, assign) int index1; // 省下标

@property (nonatomic, assign) int index2; // 市下标

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

- (NSArray *)addressArray {
    if (_addressArray == nil) {
        _addressArray = [NSArray new];
    }
    return _addressArray;
}

- (NSArray *)provinceArray {
    if (_provinceArray == nil) {
        _provinceArray = [NSArray new];
    }
    return _provinceArray;
}

- (NSArray *)countryArray{
    if (_countryArray == nil) {
        _countryArray = [NSArray new];
    }
    return _countryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@[@{@"label":@"头像",@"kind":@"image"}],@[@{@"label":@"昵称",@"kind":@"text"},@{@"label":@"性别",@"kind":@"label"},@{@"label":@"ID号",@"kind":@"label"},@{@"label":@"个性签名",@"kind":@"text"}],@[@{@"label":@"年龄",@"kind":@"text"},@{@"label":@"城市",@"kind":@"text"},@{@"label":@"收入",@"kind":@"text"},@{@"label":@"身高",@"kind":@"text"},@{@"label":@"婚姻",@"kind":@"text"}],@[@{@"label":@"学历",@"kind":@"text"},@{@"label":@"职业",@"kind":@"text"},@{@"label":@"生日",@"kind":@"text"},@{@"label":@"体重",@"kind":@"text"},@{@"label":@"星座",@"kind":@"text"},@{@"label":@"爱好",@"kind":@"text"}]];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self loadFirstMenuData];
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
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataSource[section];
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 15.f;
    }
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
    NSArray *array = _dataSource[indexPath.section];
    NSDictionary *params = array[indexPath.row];
    
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
        make.height.offset(15);
    }];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-15);
        make.width.height.offset(30);
        make.centerY.equalTo(cell.contentView);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-15);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(15);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(7);
        make.height.offset(14);
    }];
    if (indexPath.section == 0) {
        if (self.viewModel.user.userHeadImg != nil && self.viewModel.user.userHeadImg.length > 0) {
            [avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.viewModel.user.userName != nil && self.viewModel.user.userName.length > 0) {
                contentLabel.text = self.viewModel.user.userName;
            }
        } else if (indexPath.row == 1) {
            if (self.viewModel.user.userGender != nil && self.viewModel.user.userGender.length > 0) {
                contentLabel.text = self.viewModel.user.userGender;
            }
        } else if (indexPath.row == 2) {
            if (self.viewModel.user.userId != nil && self.viewModel.user.userId.length > 0) {
                contentLabel.text = self.viewModel.user.userId;
            }
        } else {
            if (self.viewModel.user.userSignature != nil && self.viewModel.user.userSignature.length > 0) {
                contentLabel.text = self.viewModel.user.userSignature;
            } else {
                contentLabel.text = @"未填写";
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if (self.viewModel.user.userAge != nil && self.viewModel.user.userAge.length > 0) {
                contentLabel.text = self.viewModel.user.userAge;
            }
        } else if (indexPath.row == 1) {
            if (self.viewModel.user.userAddress != nil && self.viewModel.user.userAddress.length > 0) {
                contentLabel.text = self.viewModel.user.userAddress;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 2) {
            if (self.viewModel.user.userIncome != nil && self.viewModel.user.userIncome.length > 0) {
                contentLabel.text = self.viewModel.user.userIncome;
            }
        } else if (indexPath.row == 3) {
            if (self.viewModel.user.userHeight != nil && self.viewModel.user.userHeight.length > 0) {
                contentLabel.text = self.viewModel.user.userHeight;
            }
        } else {
            if (self.viewModel.user.userMarry != nil && self.viewModel.user.userMarry.length > 0) {
                contentLabel.text = self.viewModel.user.userMarry;
            }
        }
    } else {
        if (indexPath.row == 0) {
            if (self.viewModel.user.userEdu != nil && self.viewModel.user.userEdu.length > 0) {
                contentLabel.text = self.viewModel.user.userEdu;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 1) {
            if (self.viewModel.user.userProfession != nil && self.viewModel.user.userProfession.length > 0) {
                contentLabel.text = self.viewModel.user.userProfession;
            }
        } else if (indexPath.row == 2) {
            if (self.viewModel.user.userBirthday != nil && self.viewModel.user.userBirthday.length > 0) {
                contentLabel.text = self.viewModel.user.userBirthday;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 3) {
            if (self.viewModel.user.userWeight != nil && self.viewModel.user.userWeight.length > 0) {
                contentLabel.text = self.viewModel.user.userWeight;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 4) {
            if (self.viewModel.user.userConstellation != nil && self.viewModel.user.userConstellation.length > 0) {
                contentLabel.text = self.viewModel.user.userConstellation;
            } else {
                contentLabel.text = @"未填写";
            }
        } else {
            if (self.viewModel.user.userSpecialty != nil && self.viewModel.user.userSpecialty.length > 0) {
                contentLabel.text = self.viewModel.user.userSpecialty;
            } else {
                contentLabel.text = @"未填写";
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 修改昵称
            NSString *value = SYStringIsNotEmpty(self.viewModel.user.userName) ? self.viewModel.user.userName : @"";
            SYNicknameModifyVM *viewModel = [[SYNicknameModifyVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:value}];
            viewModel.callback = ^(NSString *text) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userName":text}];
            };
            [self.viewModel.services presentViewModel:viewModel animated:YES completion:NULL];
        } else if (indexPath.row == 3) {
            // 修改签名
            NSString *value = SYStringIsNotEmpty(self.viewModel.user.userSignature) ? self.viewModel.user.userSignature : @"";
            SYSignatureVM *viewModel = [[SYSignatureVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:value}];
            viewModel.callback = ^(NSString *text) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userSignature":text}];
            };
            [self.viewModel.services presentViewModel:viewModel animated:YES completion:NULL];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // 选择年龄
            NSMutableArray *ageArray = [NSMutableArray new];
            for (int i = 0 ; i < 80; i++) {
                [ageArray addObject:[NSString stringWithFormat:@"%d",18 + i]];
            }
            [self showPickerWithTitle:@"请选择年龄" andDataArrays:ageArray andSelectedValue:self.viewModel.user.userAge andType:@"age"];
        } else if (indexPath.row == 1) {
            // 选择城市
            self.options = @"address";
            if (self.viewModel.user.userAddress != nil && self.viewModel.user.userAddress.length > 0) {
                [self loadFirstMenuData];   // 先查询出省级数组
                NSArray *array = [self.viewModel.user.userAddress componentsSeparatedByString:@"-"];
                for (int i = 0; i < self.provinceArray.count; i++) {
                    if ([self.provinceArray[i] isEqualToString:array[0]]) {
                        self.index1 = i;
                        break;
                    }
                }
                [self loadSecondMenuData];  // 查询出市级数组
                for (int i = 0; i < self.countryArray.count; i++) {
                    if ([self.countryArray[i] isEqualToString:array[1]]) {
                        self.index2 = i;
                        break;
                    }
                }
            } else {
                // 未设置过城市
                [self loadFirstMenuData];   // 先查询出省级数组
                self.index1 = 0;
                [self loadSecondMenuData];  // 查询出市级数组
                self.index2 = 0;
            }
            self.customPicker = [[ActionSheetCustomPicker alloc]initWithTitle:@"请选择城市" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2)]];
            self.customPicker.tapDismissAction  = TapActionSuccess;
            [self.customPicker showActionSheetPicker];
        } else if (indexPath.row == 2) {
            // 选择收入
            NSMutableArray *incomeArray = [@[@"2000以下",@"2000-5000",@"5000-10000",@"10000-20000",@"20000以上"] mutableCopy];
            [self showPickerWithTitle:@"请选择收入" andDataArrays:incomeArray andSelectedValue:self.viewModel.user.userIncome andType:@"income"];
        } else if (indexPath.row == 3) {
            // 选择身高
            NSMutableArray *heightArray = [NSMutableArray new];
            for (int i = 0 ; i <= 60; i++) {
                [heightArray addObject:[NSString stringWithFormat:@"%d",140 + i]];
            }
            [self showPickerWithTitle:@"请选择身高" andDataArrays:heightArray andSelectedValue:self.viewModel.user.userHeight andType:@"height"];
        } else {
            // 选择婚姻状态
            NSMutableArray *marryArray = [@[@"未婚",@"已婚",@"离异",@"保密"] mutableCopy];
            [self showPickerWithTitle:@"请选择婚姻状态" andDataArrays:marryArray andSelectedValue:self.viewModel.user.userMarry andType:@"marry"];
        }
    } else {
        if (indexPath.row == 0) {
            // 选择学历
            NSMutableArray *eduArray = [@[@"初中",@"中专",@"高中",@"大专",@"本科",@"本科以上"] mutableCopy];
            if (self.viewModel.user.userEdu != nil && self.viewModel.user.userEdu.length > 0) {
                [self showPickerWithTitle:@"请选择学历" andDataArrays:eduArray andSelectedValue:self.viewModel.user.userEdu andType:@"edu"];
            } else {
                [self showPickerWithTitle:@"请选择学历" andDataArrays:eduArray andSelectedValue:eduArray[0] andType:@"edu"];
            }
        } else if (indexPath.row == 1) {
            // 选择职业
            NSMutableArray *jobArray = [@[@"教师",@"工人",@"记者",@"演员",@"厨师",@"医生",@"护士",@"司机",@"军人",@"律师",@"商人",@"会计",@"店员",@"出纳",@"作家",@"导游",@"模特",@"警察",@"歌手",@"画家",@"裁缝",@"翻译",@"法官",@"保安",@"花匠",@"服务员",@"清洁工",@"建筑师",@"理发师",@"采购员",@"设计师",@"消防员",@"机修工",@"推销员",@"魔术师",@"模特儿",@"邮递员",@"售货员",@"救生员",@"运动员",@"工程师",@"飞行员",@"管理员",@"机械师",@"经纪人",@"审计员",@"漫画家",@"园艺师",@"科学家",@"主持人",@"程序员"] mutableCopy];
            [self showPickerWithTitle:@"请选择职业" andDataArrays:jobArray andSelectedValue:self.viewModel.user.userProfession andType:@"job"];
        } else if (indexPath.row == 2) {
            // 选择生日
            self.options = @"birthday";
            if (self.viewModel.user.userBirthday != nil && self.viewModel.user.userBirthday.length > 0) {
                [self loadFirstMenuData];   // 先查询出月级数组
                NSArray *array = [self.viewModel.user.userBirthday componentsSeparatedByString:@"-"];
                for (int i = 0; i < self.monthArray.count; i++) {
                    if ([self.monthArray[i] isEqualToString:array[0]]) {
                        self.index1 = i;
                        break;
                    }
                }
                [self loadSecondMenuData];  // 查询出天级数组
                for (int i = 0; i < self.dayArray.count; i++) {
                    if ([self.dayArray[i] isEqualToString:array[1]]) {
                        self.index2 = i;
                        break;
                    }
                }
            } else {
                // 未设置过生日
                [self loadFirstMenuData];
                self.index1 = 0;
                [self loadSecondMenuData];
                self.index2 = 0;
            }
            self.customPicker = [[ActionSheetCustomPicker alloc]initWithTitle:@"请选择生日" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2)]];
            self.customPicker.tapDismissAction  = TapActionSuccess;
            [self.customPicker showActionSheetPicker];
        } else if (indexPath.row == 3) {
            // 选择体重
            NSMutableArray *weightArray = [NSMutableArray new];
            for (int i = 0 ; i < 170; i++) {
                [weightArray addObject:[NSString stringWithFormat:@"%d",30 + i]];
            }
            if (self.viewModel.user.userWeight != nil && self.viewModel.user.userWeight.length > 0) {
                [self showPickerWithTitle:@"请选择体重" andDataArrays:weightArray andSelectedValue:self.viewModel.user.userWeight andType:@"weight"];
            } else {
                [self showPickerWithTitle:@"请选择体重" andDataArrays:weightArray andSelectedValue:weightArray[0] andType:@"weight"];
            }
        } else if (indexPath.row == 4) {
            // 选择星座
            NSMutableArray *constellationArray = [@[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"] mutableCopy];
            if (self.viewModel.user.userConstellation != nil && self.viewModel.user.userConstellation.length > 0) {
                [self showPickerWithTitle:@"请选择星座" andDataArrays:constellationArray andSelectedValue:self.viewModel.user.userConstellation andType:@"constellation"];
            } else {
                [self showPickerWithTitle:@"请选择星座" andDataArrays:constellationArray andSelectedValue:constellationArray[0] andType:@"weight"];
            }
        } else {
            // 选择爱好
            [self.viewModel.enterHobbyChooseViewCommand execute:nil];
        }
    }
}

// 显示滑动选择页
- (void)showPickerWithTitle:(NSString*)title andDataArrays: (NSMutableArray*)array andSelectedValue: (NSString*) value andType: (NSString*) type {
    NSInteger row = [array indexOfObject:value];
    @weakify(self)
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:array initialSelection:row doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        if ([type isEqualToString:@"age"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userAge":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"job"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userProfession":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"income"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userIncome":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"height"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userHeight":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"marry"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userMarry":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"edu"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userEdu":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"weight"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userWeight":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"constellation"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userConstellation":array[selectedIndex]}];
            }
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"取消了选择");
    } origin:self.view];
    [picker showActionSheetPicker];
}

#pragma mark - 二级级联操作
- (void)loadFirstMenuData {
    if ([self.options isEqualToString:@"address"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
        NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
        self.addressArray = [jsonStr mj_JSONObject];
        NSMutableArray *firstName = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.addressArray) {
            NSString *name = dict.allKeys.firstObject;
            [firstName addObject:name];
        }
        // 提取出所有的省份数组
        self.provinceArray = firstName;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"birthday" ofType:@"json"];
        NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
        self.birthdayArray = [jsonStr mj_JSONObject];
        NSMutableArray *firstName = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.birthdayArray) {
            NSString *name = dict.allKeys.firstObject;
            [firstName addObject:name];
        }
        // 提取出所有的月份数组
        self.monthArray = firstName;
    }
}

- (void)loadSecondMenuData {
    // 拿出一级的数组
    [self loadFirstMenuData];
    if ([self.options isEqualToString:@"address"]) {
        // 根据省的index1，默认是0，拿出对应省下面的市
        NSDictionary *cityName = self.addressArray[self.index1];
        // 组装对应省下面的市
        self.countryArray = cityName[self.provinceArray[self.index1]];
    } else {
        // 根据省的index1，默认是0，拿出对应省下面的市
        NSDictionary *dayName = self.birthdayArray[self.index1];
        // 组装对应省下面的市
        self.dayArray = dayName[self.monthArray[self.index1]];
    }
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            if ([self.options isEqualToString:@"address"]) {
                return self.provinceArray.count;
            } else {
                return self.monthArray.count;
            }
        }
            break;
        case 1: {
            if ([self.options isEqualToString:@"address"]) {
                return self.countryArray.count;
            } else {
                return self.dayArray.count;
            }
        }
            break;
        default:break;
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            if ([self.options isEqualToString:@"address"]) {
                return self.provinceArray[row];
            } else {
                return self.monthArray[row];
            }
        }
            break;
        case 1: {
            if ([self.options isEqualToString:@"address"]) {
                return self.countryArray[row];
            } else {
                return self.dayArray[row];
            }
        }
            break;
        default:break;
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = (UILabel*)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = SYRegularFont(14);
    }
    NSString * title = @"";
    switch (component) {
        case 0: {
            if ([self.options isEqualToString:@"address"]) {
                title = self.provinceArray[row];
            } else {
                title = self.monthArray[row];
            }
        }
            break;
        case 1: {
            if ([self.options isEqualToString:@"address"]) {
                title = self.countryArray[row];
            } else {
                title = self.dayArray[row];
            }
        }
            break;
        default:break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            self.index1 = row;
            self.index2 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self loadSecondMenuData];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
            break;
        case 1: {
            self.index2 = row;
        }
            break;
        default:break;
    }
}

- (void)actionSheetPicker:(AbstractActionSheetPicker *)actionSheetPicker configurePickerView:(UIPickerView *)pickerView {
    pickerView.showsSelectionIndicator = NO;
}

// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin {
    NSMutableString *detail = [[NSMutableString alloc] init];
    if ([self.options isEqualToString:@"address"]) {
        NSString *province = self.provinceArray[self.index1];
        [detail appendString:province];
    } else {
        NSString *month = self.monthArray[self.index1];
        [detail appendString:month];
    }
    [detail appendString:@"-"];
    if ([self.options isEqualToString:@"address"]) {
        NSString *country = self.countryArray[self.index2];
        [detail appendString:country];
    } else {
        NSString *day = self.dayArray[self.index2];
        [detail appendString:day];
    }
    if ([self.options isEqualToString:@"address"]) {
        if (![detail isEqualToString:self.viewModel.user.userAddress]) {
            [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userAddress":detail}];
        }
    } else {
        if (![detail isEqualToString:self.viewModel.user.userBirthday]) {
            [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userBirthday":detail}];
        }
    }
}

@end
