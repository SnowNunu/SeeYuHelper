//
//  SYSearchFriendsResultVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSearchFriendsResultVC.h"
#import "SYFriendsListCell.h"
#import "SYFriendModel.h"

@interface SYSearchFriendsResultVC ()

@property (nonatomic,strong) NSMutableArray *searchList;

@end

@implementation SYSearchFriendsResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SYFriendsListCell";
    SYFriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SYFriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SYFriendModel *model = [self.dataSource objectAtIndex:indexPath.row];
//    cell.nickNmaeLabel.text = model.nickname;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if ([self.delegate respondsToSelector:@selector(resultViewController:didSelectFollowModel:)]) {
//        [self.delegate resultViewController:self didSelectFollowModel:self.dataSource[indexPath.row]];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
