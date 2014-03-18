//
//  AppDelegate.m
//  Purdue App
//
//  Created by George Lo on 2/24/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setTintColor:PUGoldColor_TabBar];
    [[UINavigationBar appearance] setBarTintColor:PUGoldColor_NavBar];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    return YES;
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
