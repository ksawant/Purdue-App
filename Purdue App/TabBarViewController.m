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

@implementation TabBarViewController

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
    NSArray *array = [NSArray arrayWithObjects:
                      @"Maps", @"Schedule", @"Menu", @"Bus", @"News",
                      @"Photos", @"Videos", @"MyMail", @"Blackboard", @"Labs",
                      @"Directory", @"Weather", @"Store", @"Library", @"Co-Rec",
                      @"About", @"Bandwidth", @"Games", @"Settings", nil];
    NSMutableArray *controllerAry = [NSMutableArray new];
    for( int i=0; i<array.count; i++ ) {
        UINavigationController *navController;
        
        // Map
        if (i == 0) {
            MapViewController *viewController = [[MapViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [controllerAry addObject:navController];
        }
        
        else if (i == 3) {
            BusViewController *viewController = [[BusViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [controllerAry addObject:navController];
        }
        
        // Default - Haven't Implement
        else {
            UIViewController *viewController = [[UIViewController alloc] init];
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            viewController.navigationItem.title = [array objectAtIndex:i];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            view.backgroundColor = [UIColor whiteColor];
            viewController.view = view;
            [controllerAry addObject:navController];
        }
        
        // Set TabBarItems
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[array objectAtIndex:i] image:[UIImage imageNamed:[array objectAtIndex:i]] tag:i];
        [navController setTabBarItem:item];
    }
    [self setViewControllers:controllerAry];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
