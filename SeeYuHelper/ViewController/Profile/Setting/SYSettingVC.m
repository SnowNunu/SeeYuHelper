//
//  SYSettingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSettingVC.h"

@interface SYSettingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"清除缓存",@"kind":@"arrow"},@{@"label":@"关于",@"kind":@"arrow"},@{@"label":@"退出登录",@"kind":@"arrow"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
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
    NSDictionary *params = _dataSource[indexPath.row];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = params[@"label"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:contentLabel];
    
    UIButton *arrowBtn = [UIButton new];
    [arrowBtn setImage:SYImageNamed(@"tableview_arrow") forState:UIControlStateNormal];
    [cell.contentView addSubview:arrowBtn];

    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = SYColor(153, 153, 153);
    label.font = SYRegularFont(12);
    if (indexPath.row == 0) {
        label.text = [NSString stringWithFormat:@"%.2fMB",[self getFolderSize]];
    }
    [cell.contentView addSubview:label];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.width.offset(80);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowBtn.mas_left).offset(-10);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
    }];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-15);
        make.centerY.equalTo(cell.contentView);
        make.width.offset(7);
        make.height.offset(14);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        [self.viewModel.enterAboutViewCommand execute:nil];
    } else if (indexPath.row == 2) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 退出融云
            [[RCIMClient sharedRCIMClient] logout];
            // 断开websocket
            [SYSharedAppDelegate stopWebSocketService];
            // 切换至登录页面
            [self.viewModel.services.client saveUser:nil];
            [SAMKeychain setRawLogin:nil];
            // 发送通知进行页面跳转
            [SYNotificationCenter postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogout)}];
        });
    }
}

// 缓存大小
- (CGFloat)getFolderSize {
    CGFloat folderSize = 0.f;
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"文件数：%ld",files.count);
    for(NSString *path in files) {
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        //累加
        folderSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    return folderSize /1024.0/1024.0;
}

- (void)removeCache {
    //===============清除缓存==============
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
            } else {
                NSLog(@"清除失败");
            }
        }
    }
}

@end
