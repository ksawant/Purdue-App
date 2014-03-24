//
//  TabBarViewController.m
//  Purdue App
//
//  Created by George Lo on 3/11/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController {
    NSMutableArray *tabBarArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *tabTitleDict = [NSDictionary dictionaryWithObjects:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"ABOUT", nil), NSLocalizedString(@"BANDWIDTH", nil),
                                   NSLocalizedString(@"BLACKBOARD", nil), NSLocalizedString(@"BUS", nil),
                                   NSLocalizedString(@"COREC", nil), NSLocalizedString(@"DIRECTORY", nil),
                                   NSLocalizedString(@"GAMES", nil), NSLocalizedString(@"LABS", nil),
                                   NSLocalizedString(@"LIBRARY", nil), NSLocalizedString(@"MAP", nil),
                                   NSLocalizedString(@"MENU", nil), NSLocalizedString(@"MYMAIL", nil),
                                   NSLocalizedString(@"NEWS", nil), NSLocalizedString(@"PHOTOS", nil),
                                   NSLocalizedString(@"SCHEDULE", nil), NSLocalizedString(@"SETTINGS", nil),
                                   NSLocalizedString(@"STORE", nil), NSLocalizedString(@"VIDEOS", nil),
                                   NSLocalizedString(@"WEATHER", nil),
                                    nil]
                                    forKeys:
                                   [NSArray arrayWithObjects:
                                     @"0", @"1", @"2",
                                     @"3", @"4", @"5",
                                     @"6", @"7", @"8",
                                     @"9", @"10", @"11",
                                     @"12", @"13", @"14",
                                     @"15", @"16", @"17",
                                     @"18",
                                    nil]
                                  ];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TabBar_Order"] == nil) {
        NSArray *array = [NSArray arrayWithObjects:
                          @"0", @"1", @"2",
                          @"3", @"4", @"5",
                          @"6", @"7", @"8",
                          @"9", @"10", @"11",
                          @"12", @"13", @"14",
                          @"15", @"16", @"17",
                          @"18",
                          nil];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"TabBar_Order"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    tabBarArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TabBar_Order"]];
    
    NSMutableArray *controllerAry = [NSMutableArray new];
    for( int i=0; i<tabBarArray.count; i++ ) {
        UINavigationController *navController;
        NSString *tabTitle = [tabTitleDict objectForKey:[tabBarArray objectAtIndex:i]];
        
#warning Eric's Part - Please modify AboutViewController
        // About
        if ( [tabTitle isEqualToString:NSLocalizedString(@"ABOUT", nil)] ) {
            AboutViewController *viewController = [[AboutViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Bus
        if ( [tabTitle isEqualToString:NSLocalizedString(@"BUS", nil)] ) {
            BusViewController *viewController = [[BusViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Directory
        else if ( [tabTitle isEqualToString:NSLocalizedString(@"DIRECTORY", nil)] ) {
            DirectoryViewController *viewController = [[DirectoryViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Map
        else if ( [tabTitle isEqualToString:NSLocalizedString(@"MAP", nil)] ) {
            MapViewController *viewController = [[MapViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // MyMail
        else if ( [tabTitle isEqualToString:NSLocalizedString(@"MYMAIL", nil)] ) {
            MailWebViewController *viewController = [[MailWebViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Photos
        else if( [tabTitle isEqualToString:NSLocalizedString(@"PHOTOS", nil)] ) {
            PhotoViewController *viewController = [[PhotoViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Settings
        else if( [tabTitle isEqualToString:NSLocalizedString(@"SETTINGS", nil)] ) {
            SettingsViewController *viewController = [[SettingsViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Default - Haven't Implement
        else {
            UIViewController *viewController = [[UIViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            viewController.navigationItem.title = tabTitle;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            view.backgroundColor = [UIColor whiteColor];
            viewController.view = view;
        }
        
        // Add Navigation Controller to TabBar
        [controllerAry addObject:navController];
        
        // Set TabBarItems
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[tabTitleDict objectForKey:[tabBarArray objectAtIndex:i]] image:[UIImage imageNamed:[tabBarArray objectAtIndex:i]] tag:i];
        [navController setTabBarItem:item];
    }
    [self setViewControllers:controllerAry];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed {
    if (changed) {
        for ( int i=0; i<items.count-1; i++ ) {
            UITabBarItem *tabBarItem = [items objectAtIndex:i];
            // Save if the user customized tabBar
            if (![tabBarItem.title isEqualToString:[tabBarArray objectAtIndex:i]]) {
                int index = (int)[tabBarArray indexOfObject:tabBarItem.title];
                [tabBarArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%i",index]];
                [tabBarArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%i",i]];
                [[NSUserDefaults standardUserDefaults] setObject:tabBarArray forKey:@"TabBar_Order"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

@end
