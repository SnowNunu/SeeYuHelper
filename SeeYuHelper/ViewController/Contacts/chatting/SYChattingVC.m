//
//  SYChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/14.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYChattingVC.h"
#import "SYUserInfoManager.h"
#import "SYChattingListCell.h"
#import "SYTimeTool.h"
#import "SYSingleChattingVC.h"
#import "SYRCIMDataSource.h"

@interface SYChattingVC ()

@end

@implementation SYChattingVC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.conversationListTableView.tableFooterView = [UIView new];
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    self.displayConversationTypeArray = @[@(ConversationType_PRIVATE)];
//    [self.conversationListTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-SY_APPLICATION_TAB_BAR_HEIGHT);
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
//    [self.conversationListTableView reloadData];
}

// 高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
    [super rcConversationListTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    // 目前仅有私聊会话消息类型，因此暂只需要修改私聊会话的类型
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        if(model.conversationType == ConversationType_PRIVATE){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            [[SYRCIMDataSource shareInstance] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                model.conversationTitle = userInfo.name;
            }];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBadgeValue" object:nil];
    return dataSource;
}

//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    NSInteger unreadCount = model.unreadMessageCount;
    SYChattingListCell *cell = [[SYChattingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chattingListCell"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.receivedTime / 1000];
    cell.timeLabel.text = [SYTimeTool getTimeStringAutoShort2:date mustIncludeTime:NO];
    if (unreadCount == 0) {
        cell.badgeView.badgeText = nil;
    } else if(unreadCount >= 100) {
        cell.badgeView.badgeText = @"99+";
    } else {
        cell.badgeView.badgeText = [NSString stringWithFormat:@"%li",(long)unreadCount];
    }
    [cell.badgeView setNeedsLayout];
    // 根据targetId 获取用户头像昵称等信息
    [[SYRCIMDataSource shareInstance] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo * userInfo) {
        cell.aliasLabel.text = userInfo.name;
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            // 文字消息
            cell.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
        } else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]) {
            // 图片消息
            if (unreadCount > 0) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[图片]"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length)];
                cell.contentLabel.attributedText = str;
            } else {
                cell.contentLabel.text = @"[图片]";
            }
        } else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
            // 语音消息
            if (unreadCount > 0) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[语音]"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length)];
                cell.contentLabel.attributedText = str;
            } else {
                cell.contentLabel.text = @"[语音]";
            }
        } else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
            // 位置消息
            if (unreadCount > 0) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[位置]"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length)];
                cell.contentLabel.attributedText = str;
            } else {
                cell.contentLabel.text = @"[位置]";
            }
        }
        else if ([model.lastestMessage isKindOfClass:[RCCallSummaryMessage class]]) {
            RCCallSummaryMessage *message = (RCCallSummaryMessage*)model.lastestMessage;
            // 音视频消息
            if (unreadCount > 0) {
                if (message.mediaType == RCCallMediaAudio) {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[音频通话]"];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length)];
                    cell.contentLabel.attributedText = str;
                } else {
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[视频通话]"];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length)];
                    cell.contentLabel.attributedText = str;
                }
            } else {
                if (message.mediaType == RCCallMediaAudio) {
                    cell.contentLabel.text = @"[音频通话]";
                } else {
                    cell.contentLabel.text = @"[视频通话]";
                }
            }
        }
    }];
    return cell;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}


@end
