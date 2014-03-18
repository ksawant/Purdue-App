//
//  BusViewController.h
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"
#import "Stop.h"
#import "Route.h"
#import "StopDetailViewController.h"
#import "RouteDetailViewController.h"

@interface BusViewController : UITableViewController

@property (nonatomic) NSMutableArray *routesArray;
@property (nonatomic) NSMutableArray *stopsArray;
@property (nonatomic) NSMutableArray *bookmarksArray;

@end
