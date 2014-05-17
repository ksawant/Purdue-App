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

- (void)refreshInterface {
    self.navigationItem.title = NSLocalizedString(@"SETTINGS", nil);
    
    sectionTitleAry = [NSMutableArray arrayWithObjects:NSLocalizedString(@"GENERAL", nil), NSLocalizedString(@"MAP", nil), @"", nil];
    rowTitleAry = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"LANGUAGE", nil), nil], [NSArray arrayWithObjects:NSLocalizedString(@"MAPTYPE", nil), NSLocalizedString(@"MAPOVERLAY", nil), nil], [NSArray arrayWithObject:NSLocalizedString(@"SIGNOUT", nil)], nil];
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
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"STANDARD", nil), NSLocalizedString(@"SATELLITE", nil), NSLocalizedString(@"HYBRID", nil), nil] forKeys:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]];
    rowDetailAry = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:Language, nil], [NSArray arrayWithObjects:[dictionary objectForKey:[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"MapType"]]], @"", nil], [NSArray arrayWithObject:@""], nil];
    
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
    if (indexPath.section == 1 && indexPath.row == 1) {
        UISwitch *overlaySwitch = [[UISwitch alloc] init];
        overlaySwitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"NoOverlay"];
        [overlaySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = overlaySwitch;
    } else if (indexPath.section==2 ) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (IBAction)switchChanged:(id)sender {
    UISwitch *overlaySwitch = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:!overlaySwitch.on forKey:@"NoOverlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *languageAS = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"LANGUAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:@"English", @"簡體中文", @"繁體中文", @"日本語", @"español", @"한국의", nil];
            [languageAS showFromRect:[tableView cellForRowAtIndexPath:indexPath].frame inView:self.view animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIActionSheet *mapttypeAS = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"MAPTYPE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"STANDARD", nil), NSLocalizedString(@"SATELLITE", nil), NSLocalizedString(@"HYBRID", nil), nil];
            [mapttypeAS showFromRect:[tableView cellForRowAtIndexPath:indexPath].frame inView:self.view animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
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
            [self refreshInterface];
        } else if ([actionSheet.title isEqualToString:NSLocalizedString(@"MAPTYPE", nil)]) {
            [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"MapType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self refreshInterface];
        }
    }
}

@end
