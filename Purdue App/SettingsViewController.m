//
//  SettingsViewController.m
//  Purdue App
//
//  Created by George Lo on 3/22/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    NSMutableArray *sectionTitleAry;
    NSMutableArray *rowTitleAry;
    NSMutableArray *rowDetailAry;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshInterface];
}

- (void)refreshTabBar {
    NSDictionary *tabTitleDict = [NSDictionary dictionaryWithObjects:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"ABOUT", nil), NSLocalizedString(@"BANDWIDTH", nil),
                                   NSLocalizedString(@"BLACKBOARD", nil), NSLocalizedString(@"BUS", nil),
                                   NSLocalizedString(@"COREC", nil), NSLocalizedString(@"DIRECTORY", nil),
                                   NSLocalizedString(@"GAMES", nil), NSLocalizedString(@"LABS", nil),
                                   NSLocalizedString(@"LIBRARY", nil), NSLocalizedString(@"MAP", nil),
                                   NSLocalizedString(@"MENU", nil), NSLocalizedString(@"MYMAIL", nil),
                                   NSLocalizedString(@"NEWS", nil), NSLocalizedString(@"PHOTOS", nil),
                                   NSLocalizedString(@"SCHEDULE", nil), NSLocalizedString(@"SETTINGS", nil),
                                   NSLocalizedString(@"STORE", nil), NSLocalizedString(@"VIDEOS", nil),
                                   NSLocalizedString(@"WEATHER", nil),
                                   nil]
                                                             forKeys:
                                  [NSArray arrayWithObjects:
                                   @"0", @"1", @"2",
                                   @"3", @"4", @"5",
                                   @"6", @"7", @"8",
                                   @"9", @"10", @"11",
                                   @"12", @"13", @"14",
                                   @"15", @"16", @"17",
                                   @"18",
                                   nil]
                                  ];
    NSArray *tbArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TabBar_Order"] mutableCopy];
    for( int i=0; i<self.tabBarController.tabBar.items.count; i++ ) {
        [[self.tabBarController.tabBar.items objectAtIndex:i] setTitle:[tabTitleDict objectForKey:[tbArray objectAtIndex:i]]];
    }
}

- (void)refreshInterface {
    self.navigationItem.title = NSLocalizedString(@"SETTINGS", nil);
    
    sectionTitleAry = [NSMutableArray arrayWithObjects:NSLocalizedString(@"GENERAL", nil), nil];
    rowTitleAry = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"LANGUAGE", nil), nil], nil];
    NSString *Language = @"English"; // Defaults to English
    NSString *LanguageCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ( [LanguageCode isEqualToString:@"en"] ) {
        Language = @"English";
    } else if ( [LanguageCode isEqualToString:@"zh-Hant"] ) {
        Language = @"繁體中文";
    } else if ( [LanguageCode isEqualToString:@"ja"] ) {
        Language = @"日本語";
    } else if ( [LanguageCode isEqualToString:@"zh-Hans"] ) {
        Language = @"簡體中文";
    } else if ( [LanguageCode isEqualToString:@"es"] ) {
        Language = @"español";
    } else if ( [LanguageCode isEqualToString:@"ko"] ) {
        Language = @"한국의";
    }
    rowDetailAry = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:Language, nil], nil];
    
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
    return sectionTitleAry.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitleAry objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[rowTitleAry objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[rowTitleAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[rowDetailAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UIActionSheet *languageAS = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"LANGUAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:@"English", @"簡體中文", @"繁體中文", @"日本語", @"español", @"한국의", nil];
            [languageAS showFromRect:[tableView cellForRowAtIndexPath:indexPath].frame inView:self.view animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![buttonTitle isEqualToString:NSLocalizedString(@"CANCEL", nil)]) {
        if ([actionSheet.title isEqualToString:NSLocalizedString(@"LANGUAGE", nil)]) {
            if ([buttonTitle isEqualToString:@"English"]) {
                [I18NUtil setLanguage:@"en"];
            } else if ([buttonTitle isEqualToString:@"簡體中文"]) {
                [I18NUtil setLanguage:@"zh-Hans"];
            } else if ([buttonTitle isEqualToString:@"繁體中文"]) {
                [I18NUtil setLanguage:@"zh-Hant"];
            } else if ([buttonTitle isEqualToString:@"日本語"]) {
                [I18NUtil setLanguage:@"ja"];
            } else if ([buttonTitle isEqualToString:@"español"]) {
                [I18NUtil setLanguage:@"es"];
            } else if ([buttonTitle isEqualToString:@"한국의"]) {
                [I18NUtil setLanguage:@"ko"];
            }
        }
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOCAL_TITLE", nil) message:NSLocalizedString(@"LOCAL_MESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"YES", nil)]) {
        if ([alertView.title isEqualToString:NSLocalizedString(@"LOCAL_TITLE", nil)]) {
            exit(0);
        }
    }
}

@end
