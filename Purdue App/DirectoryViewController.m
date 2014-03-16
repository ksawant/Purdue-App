//
//  DirectoryViewController.m
//  Purdue App
//
//  Created by George Lo on 3/16/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "DirectoryViewController.h"

@interface DirectoryViewController ()

@end

@implementation DirectoryViewController {
    NSMutableArray *sectionTitleArray;
    NSMutableArray *rowTitleArray;
    NSMutableArray *rowDetailArray;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Override Plain
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Purdue Directory";
    
    // Init variables
    sectionTitleArray = [NSMutableArray new];
    rowTitleArray = [NSMutableArray new];
    rowDetailArray = [NSMutableArray new];
    
    // Add a Search Bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    searchBar.placeholder = @"Search for anyone";
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitleArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitleArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[rowTitleArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[rowTitleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[rowDetailArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark Search Bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    // Clear all data
    [sectionTitleArray removeAllObjects];
    [rowTitleArray removeAllObjects];
    [rowDetailArray removeAllObjects];
    [self.tableView reloadData];
    
    // Sending POST request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.itap.purdue.edu/directory/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSString *postString = [NSString stringWithFormat:@"search=%@",[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Parsing directory page
    if ([string rangeOfString:@"Your search has returned too many entries."].location != NSNotFound) {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Your search has returned too many entries" message:@"Please try narrowing your search" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlertView show];
    } else {
        NSArray *moreArray = [self getContentWithData:string usingPattern:@"alias=.*?&" withFIndex:6 andBIndex:1];
        for (NSString *purdueUser in moreArray ) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.itap.purdue.edu/directory/detail.cfm?alias=%@", purdueUser]];
            NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            // Replace all whitespace characters except space
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\f" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\x0B" withString:@""];
            
            [sectionTitleArray addObject:[[self getContentWithData:string usingPattern:@"\"Details for .*?:\"" withFIndex:13 andBIndex:2] objectAtIndex:0]];
            string = [[self getContentWithData:string usingPattern:@"<tbody>.*?</tbody>" withFIndex:0 andBIndex:0] objectAtIndex:0];
            NSMutableArray *titleArray = [NSMutableArray new];
            NSMutableArray *detailArray = [NSMutableArray new];
            for (NSString *title in [self getContentWithData:string usingPattern:@"row\">.*?<" withFIndex:5 andBIndex:2]) {
                if ([title isEqualToString:@"Career Acct. Login"]) {
                    [titleArray addObject:@"Account"];
                } else if ([title isEqualToString:@"Qualified Name"]) {
                    [titleArray addObject:@"Name"];
                } else {
                    [titleArray addObject:title];
                }
            }
            for (NSString *detail in [self getContentWithData:string usingPattern:@"td>.*?</td" withFIndex:3 andBIndex:4]) {
                NSInteger emailIndex = [detail rangeOfString:@"mailto"].location;
                if (emailIndex != NSNotFound) {
                    [detailArray addObject:[[self getContentWithData:detail usingPattern:@"mailto:.*?.edu" withFIndex:7 andBIndex:0] objectAtIndex:0]];
                } else {
                    [detailArray addObject:detail];
                }
            }
            [rowTitleArray addObject:titleArray];
            [rowDetailArray addObject:detailArray];
        }
        [self.tableView reloadData];
    }
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
