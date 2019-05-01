//
//  UITableView+SYExtension.m
//  WeChat
//
//  Created by senba on 2017/5/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "UITableView+SYExtension.h"

@implementation UITableView (SYExtension)

- (void)sy_registerCell:(Class)cls {
    
    [self sy_registerCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)sy_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerClass:cls forCellReuseIdentifier:reuseIdentifier];
}



- (void)sy_registerNibCell:(Class)cls {
    [self sy_registerNibCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
- (void)sy_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}



@end
