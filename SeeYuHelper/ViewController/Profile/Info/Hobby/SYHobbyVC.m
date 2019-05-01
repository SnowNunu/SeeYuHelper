//
//  SYHobbyVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYHobbyVC.h"
#import "SYHobbyModel.h"

@interface SYHobbyVC ()

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) NSArray *currentChooseIndexArray;

@end

@implementation SYHobbyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestHobbiesCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            for (int i = 0; i < array.count; i++) {
                SYHobbyModel *model = array[i];
                UIButton *btn = [UIButton new];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:SYColor(159, 105, 235) forState:UIControlStateNormal];
                [btn setTitle:model.hobbyName forState:UIControlStateNormal];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 15.f;
                btn.layer.borderColor = SYColor(159, 105, 235).CGColor;
                btn.layer.borderWidth = 1.f;
                btn.titleLabel.font = SYRegularFont(14);
                btn.tag = 888 + i;
                [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    [self chooseHobbyByIndex:i];
                }];
                [self.view addSubview:btn];
                
                CGFloat margin = (SY_SCREEN_WIDTH - 60 - 3 * 80) / 2;
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(80);
                    make.height.offset(30);
                    make.top.equalTo(self.tipsLabel.mas_bottom).offset(30 + i / 3 * 45);
                    make.left.equalTo(self.tipsLabel).offset(i % 3 * (margin + 80));
                }];
            }
            [self checkHobbies];
        }
    }];
    [RACObserve(self, currentChooseIndexArray) subscribeNext:^(NSArray *array) {
        NSMutableArray *tem = [NSMutableArray new];
        for (int i = 0; i < self.viewModel.datasource.count; i++) {
            [tem addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NSArray *unChooseIndexArray = [[NSArray arrayWithArray:tem] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.currentChooseIndexArray]]; //剔出未选中的下标
        for (NSString *indexString in self.currentChooseIndexArray) {
            int index = indexString.intValue;
            UIButton *btn = [self.view viewWithTag:index + 888];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:SYColor(159, 105, 235)];
        }
        for (NSString *indexString in unChooseIndexArray) {
            int index = indexString.intValue;
            UIButton *btn = [self.view viewWithTag:index + 888];
            [btn setTitleColor:SYColor(159, 105, 235) forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }];
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *hobby = @"";
        for (NSString *index in self.currentChooseIndexArray) {
            SYHobbyModel *model = self.viewModel.datasource[index.intValue];
            hobby = [NSString stringWithFormat:@"%@%@,",hobby,model.hobbyName];
        }
        hobby = [hobby substringToIndex:hobby.length - 1];
        self.viewModel.hobbyBlock(hobby);
        [self.viewModel.services popViewModelAnimated:YES];
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.textColor = SYColor(51, 51, 51);
    tipsLabel.font = SYRegularFont(16);
    tipsLabel.text = @"最多可选3个标签";
    _tipsLabel = tipsLabel;
    [self.view addSubview:tipsLabel];
    
    UIButton *submitBtn = [UIButton new];
    [submitBtn setBackgroundColor:SYColor(159, 105, 235)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn = submitBtn;
    [self.view addSubview:submitBtn];
}

- (void)_makeSubViewsConstraints {
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(30);
        make.height.offset(20);
    }];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

- (void)checkHobbies {
    if (self.viewModel.user.userSpecialty != nil && self.viewModel.user.userSpecialty.length > 0) {
        NSArray * array = [self.viewModel.user.userSpecialty componentsSeparatedByString:@","];
        NSMutableArray *temArray = [NSMutableArray new];
        for (NSString *str in array) {
            for (int i = 0; i < self.viewModel.datasource.count; i++) {
                SYHobbyModel *model = self.viewModel.datasource[i];
                if ([model.hobbyName isEqualToString:str]) {
                    [temArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
        }
        self.currentChooseIndexArray = [NSArray arrayWithArray:temArray];
    }
}

- (void)chooseHobbyByIndex:(int) index {
    BOOL oldIndex = NO;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.currentChooseIndexArray];
    // 先判断当前元素是否已经选中
    for (int i = 0; i < self.currentChooseIndexArray.count; i++) {
        NSString *value = self.currentChooseIndexArray[i];
        if (index == value.intValue) {
            // 当前元素已经选中过，则从数组中移除
            [temp removeObject:value];
            oldIndex = YES;
            break;
        }
    }
    if (!oldIndex) {
        // 如果是新的元素则先判断当前选中元素数量
        if (temp.count >= 3) {
            // 当前元素超过3个则去掉队首元素再行添加
            [temp removeObjectAtIndex:0];
            [temp addObject:[NSString stringWithFormat:@"%d",index]];
        } else {
            [temp addObject:[NSString stringWithFormat:@"%d",index]];
        }
    }
    self.currentChooseIndexArray = [NSArray arrayWithArray:temp];
}

@end
