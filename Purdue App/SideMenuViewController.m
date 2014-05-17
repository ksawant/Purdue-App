//
//  SideMenuViewController.m
//  Purdue App
//
//  Created by George Bear on 5/16/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController {
    NSMutableArray *sectionNames;
    NSDictionary *imageDict;
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
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    self.tableView.rowHeight = 40;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.4 alpha:0.65];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    sectionNames = [NSMutableArray new];
    
    [sectionNames addObject:@[NSLocalizedString(@"BLACKBOARD", nil), NSLocalizedString(@"MYMAIL", nil), NSLocalizedString(@"SCHEDULE", nil)]];
    [sectionNames addObject:@[NSLocalizedString(@"BANDWIDTH", nil), NSLocalizedString(@"BUS", nil), NSLocalizedString(@"COREC", nil), NSLocalizedString(@"GAMES", nil), NSLocalizedString(@"MENU", nil), NSLocalizedString(@"NEWS", nil), NSLocalizedString(@"WEATHER", nil)]];
    [sectionNames addObject:@[NSLocalizedString(@"LABS", nil), NSLocalizedString(@"LIBRARY", nil), NSLocalizedString(@"MAP", nil)]];
    [sectionNames addObject:@[NSLocalizedString(@"PHOTOS", nil), NSLocalizedString(@"VIDEOS", nil)]];
    [sectionNames addObject:@[NSLocalizedString(@"ABOUT", nil), NSLocalizedString(@"DIRECTORY", nil), NSLocalizedString(@"SETTINGS", nil), NSLocalizedString(@"STORE", nil)]];
    
    imageDict = @{
                    NSLocalizedString(@"BLACKBOARD", nil): @"Blackboard",
                    NSLocalizedString(@"MYMAIL", nil): @"MyMail",
                    NSLocalizedString(@"SCHEDULE", nil): @"Schedule",
                      
                    NSLocalizedString(@"BANDWIDTH", nil): @"Bandwidth",
                    NSLocalizedString(@"BUS", nil): @"Bus",
                    NSLocalizedString(@"COREC", nil): @"Co-Rec",
                    NSLocalizedString(@"GAMES", nil): @"Games",
                    NSLocalizedString(@"MENU", nil): @"Menu",
                    NSLocalizedString(@"NEWS", nil): @"News",
                    NSLocalizedString(@"WEATHER", nil): @"Weather",
                      
                    NSLocalizedString(@"LABS", nil): @"Labs",
                    NSLocalizedString(@"LIBRARY", nil): @"Library",
                    NSLocalizedString(@"MAP", nil): @"Map",
                        
                    NSLocalizedString(@"PHOTOS", nil): @"Photos",
                    NSLocalizedString(@"VIDEOS", nil): @"Videos",
                        
                    NSLocalizedString(@"ABOUT", nil): @"About",
                    NSLocalizedString(@"DIRECTORY", nil): @"Directory",
                    NSLocalizedString(@"SETTINGS", nil): @"Settings",
                    NSLocalizedString(@"STORE", nil): @"Store",
                 };
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
    return sectionNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sectionNames[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for( UIView *view in cell.contentView.subviews ) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [[sectionNames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    CGSize itemSize = CGSizeMake(10, 15);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
    imageView.image = [ApplicationDelegate maskImage:[UIImage imageNamed:[imageDict objectForKey:cell.textLabel.text]] withColor:[UIColor whiteColor]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    
    return cell;
}

@end
