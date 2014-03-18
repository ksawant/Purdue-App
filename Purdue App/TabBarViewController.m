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
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TabBar_Order"] == nil) {
        NSArray *array = [NSArray arrayWithObjects:
                          @"Map", @"Schedule", @"Menu", @"Bus", @"News",
                          @"Photos", @"Videos", @"MyMail", @"Blackboard", @"Labs",
                          @"Directory", @"Weather", @"Store", @"Library", @"Co-Rec",
                          @"About", @"Bandwidth", @"Games", @"Settings", nil];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"TabBar_Order"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    tabBarArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TabBar_Order"]];
    
    NSMutableArray *controllerAry = [NSMutableArray new];
    for( int i=0; i<tabBarArray.count; i++ ) {
        UINavigationController *navController;
        
        // Bus
        if ( [[tabBarArray objectAtIndex:i] isEqualToString:@"Bus"] ) {
            BusViewController *viewController = [[BusViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Directory
        else if ( [[tabBarArray objectAtIndex:i] isEqualToString:@"Directory"] ) {
            DirectoryViewController *viewController = [[DirectoryViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Map
        else if ( [[tabBarArray objectAtIndex:i] isEqualToString:@"Map"] ) {
            MapViewController *viewController = [[MapViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // MyMail
        else if ( [[tabBarArray objectAtIndex:i] isEqualToString:@"MyMail"] ) {
            MailWebViewController *viewController = [[MailWebViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        else if( [[tabBarArray objectAtIndex:i] isEqualToString:@"Photos"] ) {
            PhotoViewController *viewController = [[PhotoViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        }
        
        // Default - Haven't Implement
        else {
            UIViewController *viewController = [[UIViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            viewController.navigationItem.title = [tabBarArray objectAtIndex:i];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            view.backgroundColor = [UIColor whiteColor];
            viewController.view = view;
        }
        
        // Add Navigation Controller to TabBar
        [controllerAry addObject:navController];
        
        // Set TabBarItems
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[tabBarArray objectAtIndex:i] image:[UIImage imageNamed:[tabBarArray objectAtIndex:i]] tag:i];
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
                NSInteger index = [tabBarArray indexOfObject:tabBarItem.title];
                NSString *tempTitle = [tabBarArray objectAtIndex:i];
                [tabBarArray replaceObjectAtIndex:i withObject:tabBarItem.title];
                [tabBarArray replaceObjectAtIndex:index withObject:tempTitle];
                [[NSUserDefaults standardUserDefaults] setObject:tabBarArray forKey:@"TabBar_Order"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

@end
