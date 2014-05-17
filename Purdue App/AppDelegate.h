//
//  AppDelegate.h
//  Purdue App
//
//  Created by George Lo on 2/24/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "BandwidthViewController.h"
#import "BlackboardViewController.h"
#import "BusViewController.h"
#import "DirectoryViewController.h"
#import "MapViewController.h"
#import "MailWebViewController.h"
#import "MenuViewController.h"
#import "PhotoViewController.h"
#import "ScheduleViewController.h"
#import "SettingsViewController.h"
#import "StoreViewController.h"
#import "VideosViewController.h"
#import "WeatherViewController.h"

#import "SideMenuViewController.h"
#import "ECSlidingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITableViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ECSlidingViewController *slidingViewController;

- (NSArray*) getContentWithData:(NSString*)dataString usingPattern:(NSString *)patternStr withFIndex:(int)fIndex andBIndex:(int) bIndex;
- (UIImage *)maskImage:(UIImage *)image withColor:(UIColor *)color;

@end
