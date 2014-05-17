//
//  AppDelegate.m
//  Purdue App
//
//  Created by George Lo on 2/24/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate {
    NSMutableArray *categoryNames;
    NSIndexPath *selectedIP;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:PUGoldColor_NavBar];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [I18NUtil initialize];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MailWebViewController *topViewController = [[MailWebViewController alloc] init];
    SideMenuViewController *leftViewController = [[SideMenuViewController alloc] init];
    leftViewController.tableView.delegate = self;
    
    topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SideMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu:)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topViewController];
    
    // configure sliding view controller
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:navigationController];
    self.slidingViewController.underLeftViewController = leftViewController;
    
    // enable swiping on the top view
    [navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // configure anchored layout
    self.slidingViewController.anchorRightPeekAmount  = 80.0;
    
    self.window.rootViewController = self.slidingViewController;
    [self.window makeKeyAndVisible];
    
    categoryNames = [NSMutableArray arrayWithObjects:
                     NSLocalizedString(@"ACADEMICS", nil),
                     NSLocalizedString(@"LIFE", nil),
                     NSLocalizedString(@"MAPS", nil),
                     NSLocalizedString(@"MEDIA", nil),
                     NSLocalizedString(@"OTHERS", nil),
                     nil];
    
    return YES;
}

- (IBAction)showMenu:(id)sender {
    if (self.slidingViewController.currentTopViewPosition == 2) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    } else if (self.slidingViewController.currentTopViewPosition == 1){
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    headerLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    headerLabel.text = [NSString stringWithFormat:@"  %@",[categoryNames[section] uppercaseString]];
    headerLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    headerLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIP) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIP];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)view;
                imageView.image = [self maskImage:imageView.image withColor:[UIColor whiteColor]];
            }
        }
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    cell.textLabel.textColor = PUGoldColor_RealCl;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.image = [self maskImage:imageView.image withColor:PUGoldColor_RealCl];
        }
    }
    
    UIViewController *topViewController;
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"BLACKBOARD", nil)]) {
        topViewController = [BlackboardViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"MYMAIL", nil)]) {
        topViewController = [MailWebViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"SCHEDULE", nil)]) {
        topViewController = [ScheduleViewController new];
    }
    
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"BANDWIDTH", nil)]) {
        topViewController = [BandwidthViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"BUS", nil)]) {
        topViewController = [BusViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"COREC", nil)]) {
        //topViewController = [CorecViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"GAMES", nil)]) {
        //topViewController = [MailWebViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"MENU", nil)]) {
        topViewController = [MenuViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"NEWS", nil)]) {
        //topViewController = [NewsViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"WEATHER", nil)]) {
        topViewController = [WeatherViewController new];
    }
    
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"LABS", nil)]) {
        //topViewController = [LabsViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"LIBRARY", nil)]) {
        //topViewController = [MailWebViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"MAP", nil)]) {
        topViewController = [MapViewController new];
    }
    
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"PHOTOS", nil)]) {
        topViewController = [PhotoViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"VIDEOS", nil)]) {
        topViewController = [VideosViewController new];
    }
    
    else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"ABOUT", nil)]) {
        topViewController = [AboutViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"DIRECTORY", nil)]) {
        topViewController = [DirectoryViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"SETTINGS", nil)]) {
        topViewController = [SettingsViewController new];
    } else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"STORE", nil)]) {
        topViewController = [StoreViewController new];
    }
    
    topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SideMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu:)];
    [self.slidingViewController setTopViewController:[[UINavigationController alloc] initWithRootViewController:topViewController]];
    selectedIP = indexPath;
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (UIImage *)maskImage:(UIImage *)image withColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray*) getContentWithData:(NSString*)dataString usingPattern:(NSString *)patternStr withFIndex:(int)fIndex andBIndex:(int) bIndex {
    
    // Setup Regular Expression matching
    NSMutableArray *resultsAry = [NSMutableArray new];
    NSRegularExpression* regex = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchAry=[regex matchesInString:dataString options:0 range:NSMakeRange(0, dataString.length)];
    
    // Regular Expression objects are returned in NSTextCheckingResult types
    for( NSTextCheckingResult *match in matchAry) {
        NSString *result=[dataString substringWithRange:[match range]];
        [resultsAry addObject:[result substringWithRange:NSMakeRange(fIndex,result.length-bIndex-fIndex) ]];
    }
    
    return resultsAry;
}

@end
