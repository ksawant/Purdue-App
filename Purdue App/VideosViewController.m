//
//  VideosViewController.m
//  Purdue App
//
//  Created by George Lo on 4/11/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "VideosViewController.h"

@interface VideosViewController ()

@end

@implementation VideosViewController {
    NSMutableArray *linkAry;
    NSMutableArray *imageAry;
    NSMutableArray *titleAry;
    NSMutableArray *detailAry;
}

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
    
    self.tableView.rowHeight = 60;
    
    linkAry = [NSMutableArray new];
    imageAry = [NSMutableArray new];
    titleAry = [NSMutableArray new];
    detailAry = [NSMutableArray new];
    
    self.navigationItem.title = NSLocalizedString(@"VIDEOS", nil);
    
    MRProgressOverlayView *view = [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];
    view.mode = MRProgressOverlayViewModeIndeterminate;
    view.titleLabelText = NSLocalizedString(@"LOADING", nil);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/PurdueUniversity/uploads?alt=json&start-index=1&max-results=25&v=2"]];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *videoAry = [[dictionary objectForKey:@"feed"] objectForKey:@"entry"];
        for (NSDictionary *entryDict in videoAry) {
            [linkAry addObject:[[[entryDict objectForKey:@"link"] objectAtIndex:0] objectForKey:@"href"]];
            [imageAry addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[entryDict objectForKey:@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:0] objectForKey:@"url"]]]]];
            [titleAry addObject:[[[entryDict objectForKey:@"media$group"] objectForKey:@"media$title"] objectForKey:@"$t"]];
            [detailAry addObject:[[[entryDict objectForKey:@"media$group"] objectForKey:@"media$description"] objectForKey:@"$t"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [view dismiss:YES];
        });
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
    return linkAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [imageAry objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [titleAry objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    cell.detailTextLabel.text = [detailAry objectAtIndex:indexPath.row];
    cell.detailTextLabel.numberOfLines = 3;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.navigationItem.title = [titleAry objectAtIndex:indexPath.row];
    UIWebView *webView = [[UIWebView alloc] init];
    viewController.view = webView;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[linkAry objectAtIndex:indexPath.row]]]];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
