//
//  MenuViewController.m
//  Purdue App
//
//  Created by George Lo on 4/11/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    NSArray *locationAry;
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
    
    self.navigationItem.title = NSLocalizedString(@"LOCATIONS", nil);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *menuData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.hfs.purdue.edu/menus/v2/locations/"]];
    locationAry = [NSJSONSerialization JSONObjectWithData:menuData options:NSJSONReadingAllowFragments error:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchBtn setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [searchBtn addTarget:self action:@selector(searchPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}

- (IBAction)searchPressed:(id)sender {
    // Bring up search display controller...
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
    return locationAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [locationAry objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
