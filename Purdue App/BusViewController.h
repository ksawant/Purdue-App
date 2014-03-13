//
//  BusViewController.h
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProgress.h"
#import "Route.h"
#import "Stop.h"
#import "StopDetailViewController.h"

@interface BusViewController : UITableViewController

@property (nonatomic) NSMutableArray *routesArray;
@property (nonatomic) NSMutableArray *stopsArray;

@end
