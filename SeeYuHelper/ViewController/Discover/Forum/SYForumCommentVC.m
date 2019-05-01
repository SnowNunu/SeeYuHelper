//
//  SYForumCommentVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumCommentVC.h"
#import "SYForumHeaderCell.h"
#import "SYMomentCommentToolView.h"
#import "SYForumResultModel.h"
#import "UIScrollView+SYRefresh.h"

@interface SYForumCommentVC() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SYMomentCommentToolView *commentToolView;

/// 记录键盘高度
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation SYForumCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复话题";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestForumsCommentsCommand execute:@1];
}

- (void)bindViewModel {
    @weakify(self)
    [[RACObserve(self.viewModel, datasource) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    //// 监听commentToolView的高度变化
    [[RACObserve(self.commentToolView, toHeight) distinctUntilChanged] subscribeNext:^(NSNumber * toHeight) {
        @strongify(self);
        if (toHeight.floatValue < SYMomentCommentToolViewMinHeight) return ;
        /// 更新CommentView的高度
        [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(toHeight);
        }];
        [UIView animateWithDuration:.25f animations:^{
            // 适当时候更新布局
            [self.view layoutSubviews];
            /// 滚动表格
            [self _scrollTheTableViewForComment];
        }];
    }];
    /// 监听键盘 高度
    /// 监听按钮
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] takeUntil:self.rac_willDeallocSignal ]
      deliverOnMainThread]
     subscribeNext:^(NSNotification * notification) {
         @strongify(self);
         @weakify(self);
         [self sy_convertNotification:notification completion:^(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH) {
             @strongify(self);
             if (keyboardH == self.keyboardHeight) {
                 // 这里会收到3次键盘通知，需要进行重复操作判断
                 return ;
             }
             if (keyboardH <= 0) {
                 keyboardH = -self.keyboardHeight;
             }
             self.keyboardHeight = keyboardH;
             /// 全局记录keyboardH
             SYSharedAppDelegate.showKeyboard = (keyboardH > 0);
             if (keyboardH > 0) {
                 [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.bottom.equalTo(self.view).with.offset(-1 *keyboardH);
                 }];
             } else {
                 [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.bottom.equalTo(self.view);
                 }];
             }
             // 执行动画
             [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
                 // 如果是Masonry或者autoLayout UITextField或者UITextView 布局 必须layoutSubviews，否则文字会跳动
                 [self.view layoutSubviews];
                 /// 滚动表格
                 [self _scrollTheTableViewForComment];
             } completion:nil];
         }];
     }];
    [[self.commentToolView.releaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.commentToolView.textView.text.length > 0) {
            [MBProgressHUD sy_showProgressHUD:@"发表中，请稍候" addedToView:self.view];
            [self.viewModel.postCommentCommand execute:self.commentToolView.textView.text];
        }
        NSLog(@"%@",self.commentToolView.textView.text);
    }];
    [self.viewModel.postCommentCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYForumResultModel *model) {
        @strongify(self)
        [MBProgressHUD sy_hideHUDForView:self.view];
        [MBProgressHUD sy_showTips:@"评论发布成功"];
        self.commentToolView.textView.text = nil;
        [self.commentToolView.textView resignFirstResponder];
    }];
    [self.viewModel.postCommentCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUDForView:self.view];
        [MBProgressHUD sy_showErrorTips:error];
    }];
    [self.viewModel.likeCommentCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYForumResultModel *model) {
        @strongify(self)
        [MBProgressHUD sy_showTips:@"操作成功"];
        self.commentToolView.textView.text = nil;
        [self.commentToolView.textView resignFirstResponder];
    }];
    [self.viewModel.likeCommentCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SYForumCommentCell class] forCellReuseIdentifier:@"forumCommentCell"];
    [tableView registerClass:[SYForumHeaderCell class] forCellReuseIdentifier:@"forumHeaderCell"];
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    // 添加下拉刷新控件
    @weakify(self);
    [self.tableView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerHeaderRefresh];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    /// 上拉加载
    [self.tableView sy_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        /// 加载上拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerFooterRefresh];
    }];
    
    SYMomentCommentToolView *commentToolView = [[SYMomentCommentToolView alloc] init];
    self.commentToolView = commentToolView;
    [self.view addSubview:commentToolView];
    [commentToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.view);
    }];
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}

#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestForumsCommentsCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum = 1;
        [self.tableView.mj_footer resetNoMoreData];
    } error:^(NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }];
}

#pragma mark - 上拉刷新事件
- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestForumsCommentsCommand execute:@(self.viewModel.pageNum + 1)] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum += 1;
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma  mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SYForumHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumHeaderCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[SYForumHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forumHeaderCell"];
        }
        cell.titleLabel.text = self.viewModel.model.forumTitle;
        cell.contentLabel.text = self.viewModel.model.forumContent;
        if (self.viewModel.model.forumPhoto != nil && self.viewModel.model.forumPhoto.length > 0) {
            [cell setTitleImageViewByUrl:self.viewModel.model.forumPhoto];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        SYForumCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumCommentCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[SYForumCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forumListCell"];
        }
        SYForumCommentModel *model = self.viewModel.datasource[indexPath.row];
        [cell.headPhotoView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        cell.aliasLabel.text = model.userName;
        cell.contentLabel.text = model.commentContent;
        cell.genderImageView.image = [model.userGender isEqualToString:@"男"] ? SYImageNamed(@"news_icon_male") : SYImageNamed(@"news_icon_female");
        cell.likeNumLabel.text = model.commentLiked;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([model.likedStatus isEqualToString:@"1"]) {
                // 取消点赞
                model.likedStatus = @"0";
                int num = [model.commentLiked intValue];
                model.commentLiked = [NSString stringWithFormat:@"%d",num - 1];
                cell.likeNumLabel.text = model.commentLiked;
                cell.likeBtn.selected = NO;
            } else {
                // 取消点赞
                model.likedStatus = @"1";
                int num = [model.commentLiked intValue];
                model.commentLiked = [NSString stringWithFormat:@"%d",num + 1];
                cell.likeNumLabel.text = model.commentLiked;
                cell.likeBtn.selected = YES;
            }
            [self.viewModel.likeCommentCommand execute:model.commentId];
        }];
        if ([model.likedStatus isEqualToString:@"1"]) {
            cell.likeBtn.selected = YES;
        } else {
            cell.likeBtn.selected = NO;
        }
        return cell;
    }
}

/// 评论的时候 滚动tableView
- (void)_scrollTheTableViewForComment {
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + self.keyboardHeight) animated:NO];
}

@end
