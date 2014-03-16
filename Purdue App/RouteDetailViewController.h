//
//  RouteDetailViewController.h
//  Purdue App
//
//  Created by George Lo on 3/15/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"
#import "StopDetailViewController.h"

@interface RouteDetailViewController : UITableViewController

@property (nonatomic) NSString *routeName;
@property (nonatomic) NSArray *stopsArray;
@property (nonatomic) NSDictionary *routesDict;

@end
