//
//  StopDetailViewController.m
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "StopDetailViewController.h"

@interface StopDetailViewController ()

@end

@implementation StopDetailViewController {
    NSMutableArray *busArray;
    NSMutableArray *timeArray;
    NSMutableArray *bookmarksArray;
    NSTimer *refreshTimer;
}

@synthesize currentStop;
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
    
    busArray = [NSMutableArray new];
    timeArray = [NSMutableArray new];
    
    // Set up NavigationBar
    self.navigationItem.title = currentStop.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Bookmark"] style:UIBarButtonItemStyleBordered target:self action:@selector(addBookmark:)];
    
    // Determine if the stop has been bookmarked
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bus_Bookmarks"];
    bookmarksArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for( Stop *stop in bookmarksArray ) {
        if (stop.Id == currentStop.Id) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Bookmarked"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteBookmark:)];
            break;
        }
    }
    
    // Refresh Bus every 10 seconds
    [self refreshBusTimes:nil];
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshBusTimes:) userInfo:nil repeats:YES];
}

- (IBAction)addBookmark:(id)sender {
    // Add Bookmark
    [bookmarksArray addObject:currentStop];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bookmarksArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Bus_Bookmarks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Change to deleteBookmark BarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Bookmarked"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteBookmark:)];
}

- (IBAction)deleteBookmark:(id)sender {
    // Remove Bookmark
    for( Stop *stop in bookmarksArray ) {
        if (stop.Id == currentStop.Id) {
            [bookmarksArray removeObject:stop];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bookmarksArray];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Bus_Bookmarks"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    // Change to addBookmark BarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Bookmark"] style:UIBarButtonItemStyleBordered target:self action:@selector(addBookmark:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [refreshTimer invalidate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)refreshBusTimes:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [busArray removeAllObjects];
    [timeArray removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *detailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://citybus.doublemap.com/map/v2/eta?stop=%li",(long)currentStop.Id]]];
        NSDictionary *detailDict = [NSJSONSerialization JSONObjectWithData:detailData options:NSJSONReadingAllowFragments error:nil];
        if( detailDict.count>0 ) {
            detailDict = [[detailDict objectForKey:@"etas"] objectForKey:[NSString stringWithFormat:@"%li",(long)currentStop.Id]];
            for( NSDictionary *dict in [detailDict objectForKey:@"etas"] ) {
                [busArray addObject:[routesDict objectForKey:[[dict objectForKey:@"route"] stringValue]]];
                [timeArray addObject:[[dict objectForKey:@"avg"] stringValue]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                CWStatusBarNotification *notification = [CWStatusBarNotification new];
                notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
                notification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
                [notification displayNotificationWithMessage:@"No Incoming Bus" forDuration:2.0f];
            });
        }
    });
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
    return busArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [busArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [timeArray objectAtIndex:indexPath.row], NSLocalizedString(@"MIN", nil)];
    NSInteger time = [[timeArray objectAtIndex:indexPath.row] integerValue];
    if (time <= 1) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    } else if (time <= 5) {
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"ROUTETIME", nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
