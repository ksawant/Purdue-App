//
//  WeatherViewController.m
//  Purdue App
//
//  Created by George Lo on 3/31/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Condition request
        NSURL *conditionUrl = [NSURL URLWithString:@"http://api.wunderground.com/api/5b62669a811c7768/conditions/q/IN/West_Lafayette.json"];
        NSData *conditionData = [NSData dataWithContentsOfURL:conditionUrl];
        NSDictionary *conditionDict = [NSJSONSerialization JSONObjectWithData:conditionData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *observation = [conditionDict objectForKey:@"observation"];
        NSString *tempF = [observation objectForKey:@"temp_f"];
        NSString *tempC = [observation objectForKey:@"temp_c"];
        NSString *windDegress = [observation objectForKey:@"wind_degress"];
        NSString *windMPH = [observation objectForKey:@"wind_mph"];
        NSString *windKPH = [observation objectForKey:@"wind_kph"];
        NSString *feelF = [observation objectForKey:@"feelslike_f"];
        NSString *feelC = [observation objectForKey:@"feelslike_c"];
        NSString *weather = [observation objectForKey:@"weather"]; // Clear
        
        // Forecast request
        NSURL *forecastUrl = [NSURL URLWithString:@"http://api.wunderground.com/api/5b62669a811c7768/forecast/q/IN/West_Lafayette.json"];
        NSData *forecastData = [NSData dataWithContentsOfURL:forecastUrl];
        NSDictionary *forecastDict = [NSJSONSerialization JSONObjectWithData:forecastData options:NSJSONReadingAllowFragments error:nil];
        
        // Hourly request
        NSURL *hourlyUrl = [NSURL URLWithString:@"http://api.wunderground.com/api/5b62669a811c7768/hourly/q/IN/West_Lafayette.json"];
        NSData *hourlyData = [NSData dataWithContentsOfURL:hourlyUrl];
        NSDictionary *hourlyDict = [NSJSONSerialization JSONObjectWithData:hourlyData options:NSJSONReadingAllowFragments error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
        });
    });
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
