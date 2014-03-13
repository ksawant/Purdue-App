//
//  BusViewController.m
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "BusViewController.h"

typedef enum {
    TVOptionRoutes = 1,
    TVOptionStops = 2,
    TVOptionBookmarks = 3
} TableViewOption;

@interface BusViewController ()

@end

@implementation BusViewController {
    TableViewOption currentOption;
    NSMutableDictionary *routesDict;
}

@synthesize routesArray;
@synthesize stopsArray;

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
    
    // Disable backBarButtonItem title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];;
    
    // Init variables
    routesArray = [NSMutableArray new];
    stopsArray = [NSMutableArray new];
    routesDict = [NSMutableDictionary new];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Routes", @"Stops", @"Bookmarks", nil]];
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
    // Loading Indicator - for good UX
    MRProgressOverlayView *pov = [MRProgressOverlayView showOverlayAddedTo:self.parentViewController.view animated:YES];
    pov.titleLabelText = @"Loading";
    pov.mode = MRProgressOverlayViewModeIndeterminate;
    
    // Use two different dispatch priority queues to retrieve data
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *routeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:Bus_Routes_URL]];
        NSArray *routeArray = [NSJSONSerialization JSONObjectWithData:routeData options:NSJSONReadingAllowFragments error:nil];
        for( NSDictionary *routeDict in routeArray ) {
            Route *route = [[Route alloc] init];
            route.Id = [[routeDict objectForKey:@"id"] integerValue];
            route.name = [routeDict objectForKey:@"name"];
            route.short_name = [routeDict objectForKey:@"short_name"];
            route.description = [routeDict objectForKey:@"description"];
            route.color = [routeDict objectForKey:@"color"];
            route.schedule = [routeDict objectForKey:@"schedule"];
            route.active = [[routeDict objectForKey:@"active"] boolValue];
            route.path = [routeDict objectForKey:@"path"];
            route.stops = [routeDict objectForKey:@"stops"];
            [routesArray addObject:route];
            
            [routesDict setObject:[routeDict objectForKey:@"name"] forKey:[[routeDict objectForKey:@"id"] stringValue]];
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *stopData = [NSData dataWithContentsOfURL:[NSURL URLWithString:Bus_Stops_URL]];
        NSArray *stopArray = [NSJSONSerialization JSONObjectWithData:stopData options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *duplicateArray = [NSMutableArray new];
        for( NSDictionary *stopDict in stopArray ) {
            Stop *stop = [[Stop alloc] init];
            stop.Id = [[stopDict objectForKey:@"id"] integerValue];
            stop.name = [stopDict objectForKey:@"name"];
            stop.description = [stopDict objectForKey:@"description"];
            stop.coordinate = CLLocationCoordinate2DMake([[stopDict objectForKey:@"lat"] floatValue], [[stopDict objectForKey:@"lon"] floatValue]);
            stop.buddy = [[stopDict objectForKey:@"buddy"] integerValue];
            stop.announce = [[stopDict objectForKey:@"announce"] boolValue];
            
            BOOL added = NO;
            for( int i=0; i<stopsArray.count; i++ ) {
                Stop *compareStop = (Stop *)[stopsArray objectAtIndex:i];
                if( [compareStop.name isEqualToString:stop.name] ) {
                    [stopsArray removeObjectAtIndex:i];
                    [stopsArray addObject:stop];
                    added = YES;
                }
            }
            if (!added) {
                [stopsArray addObject:stop];
            }
            
            // Sort stops since it's not organized
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [stopsArray sortUsingDescriptors:sortDescriptors];
        }
    });
    
    // Wait until Routes and Stops are ready
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        currentOption = TVOptionRoutes;
        dispatch_async(dispatch_get_main_queue(), ^{
            pov.titleLabelText = @"Done";
            pov.mode = MRProgressOverlayViewModeCheckmark;
            // 1.0 seconds for a smoother transition
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [pov dismiss:YES];
                [self.tableView reloadData];
            });
        });
    });
}

#pragma mark Segment Change Event

- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    currentOption = (int)control.selectedSegmentIndex+1;
    [self.tableView reloadData];
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
    if (currentOption == TVOptionRoutes)
        return routesArray.count;
    else if (currentOption == TVOptionStops)
        return stopsArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (currentOption == TVOptionRoutes) {
        Route *route = [routesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = route.name;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    } else if (currentOption == TVOptionStops) {
        Stop *stop = [stopsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = stop.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
    } else {
        cell.textLabel.text = nil;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentOption == TVOptionRoutes) {
        
    }
    else if (currentOption == TVOptionStops) {
        StopDetailViewController *sdvc = [[StopDetailViewController alloc] init];
        sdvc.stopId = ((Stop *)[stopsArray objectAtIndex:indexPath.row]).Id;
        sdvc.stopName = ((Stop *)[stopsArray objectAtIndex:indexPath.row]).name;
        sdvc.routesDict = routesDict;
        [self.navigationController pushViewController:sdvc animated:YES];
    }
    else if (currentOption == TVOptionBookmarks) {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
