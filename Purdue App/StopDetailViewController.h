//
//  StopDetailViewController.h
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStatusBarNotification.h"

@interface StopDetailViewController : UITableViewController

@property (nonatomic) NSInteger stopId;
@property (nonatomic) NSString *stopName;
@property (nonatomic) NSDictionary *routesDict;

@end
