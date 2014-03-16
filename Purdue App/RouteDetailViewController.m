//
//  RouteDetailViewController.m
//  Purdue App
//
//  Created by George Lo on 3/15/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "RouteDetailViewController.h"

@interface RouteDetailViewController ()

@end

@implementation RouteDetailViewController

@synthesize routeName;
@synthesize stopsArray;
@synthesize routesDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Title on NavigationBar to be the route's name
    self.navigationItem.title = routeName;
    
    // Disable backBarButtonItem title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return stopsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 2;
    
    Stop *stop = [stopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = stop.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StopDetailViewController *sdvc = [[StopDetailViewController alloc] init];
    Stop *stop = [stopsArray objectAtIndex:indexPath.row];
    sdvc.currentStop = stop;
    sdvc.routesDict = routesDict;
    [self.navigationController pushViewController:sdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
