//
//  SYNearbyVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/24.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYNearbyVM.h"
#import "SYTableView.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNearbyVC : SYVC <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) SYTableView *tableView;

@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong) NSString *city;

@end

NS_ASSUME_NONNULL_END
