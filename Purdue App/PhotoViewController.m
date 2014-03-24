//
//  PhotoViewController.m
//  Purdue App
//
//  Created by George Lo on 3/16/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController {
    NSMutableArray *albumArray;
    NSMutableArray *photos;
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
    
    self.navigationItem.title = NSLocalizedString(@"RECENTPHOTOS", nil);
    albumArray = [NSMutableArray new];
    
    MRProgressOverlayView *pov = [MRProgressOverlayView showOverlayAddedTo:self.parentViewController.view animated:YES];
    pov.titleLabelText = NSLocalizedString(@"LOADING", nil);
    pov.mode = MRProgressOverlayViewModeIndeterminate;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *htmlStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.purdueexponent.org/gallery/"] encoding:NSUTF8StringEncoding error:nil];
        
        // Replace all whitespace characters except space
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\x0B" withString:@""];
        
        for (NSString *albumHtmlStr in [ApplicationDelegate getContentWithData:htmlStr usingPattern:@"<li>            <.*?</li>" withFIndex:0 andBIndex:0] ) {
            Album *album = [[Album alloc] init];
            album.thumbnail = [self resizeImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ApplicationDelegate getContentWithData:albumHtmlStr usingPattern:@"src=\".*?alt" withFIndex:5 andBIndex:5] objectAtIndex:0]]]] withSize:CGSizeMake(70, 44)];
            NSString *ahref = [[ApplicationDelegate getContentWithData:albumHtmlStr usingPattern:@"ong><a href=\".*?</a>" withFIndex:13 andBIndex:4] objectAtIndex:0];
            album.title = [[ahref componentsSeparatedByString:@"\">"] objectAtIndex:1];
            album.numPhotos = [[ApplicationDelegate getContentWithData:albumHtmlStr usingPattern:@"heading\"><p>.*?</p>" withFIndex:12 andBIndex:4] objectAtIndex:0];
            album.urlString = [NSString stringWithFormat:@"http://www.purdueexponent.org%@",[[ahref componentsSeparatedByString:@"\">"] objectAtIndex:0]];
            [albumArray addObject:album];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            pov.titleLabelText = NSLocalizedString(@"DONE", nil);
            pov.mode = MRProgressOverlayViewModeCheckmark;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [pov dismiss:YES];
            });
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
    return albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Album *album = [albumArray objectAtIndex:indexPath.row];
    cell.textLabel.text = album.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.text = album.numPhotos;
    cell.imageView.image = album.thumbnail;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    photos = [NSMutableArray new];
    
    Album *album = [albumArray objectAtIndex:indexPath.row];
    NSString *htmlStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:album.urlString] encoding:NSUTF8StringEncoding error:nil];
    for (NSString *imgStr in [ApplicationDelegate getContentWithData:htmlStr usingPattern:@"<img.*?width=\"600\" style=\"max-width:760px\"/>" withFIndex:0 andBIndex:0]) {
        NSString *imgUrl = [[ApplicationDelegate getContentWithData:imgStr usingPattern:@"src=\".*?\"" withFIndex:5 andBIndex:1] objectAtIndex:0];
        NSString *title = [[ApplicationDelegate getContentWithData:imgStr usingPattern:@"alt=\".*?\"" withFIndex:5 andBIndex:1] objectAtIndex:0];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]];
        photo.caption = title;
        [photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayNavArrows = YES;
    browser.alwaysShowControls = YES;
    browser.startOnGrid = YES;
    [self.navigationController pushViewController:browser animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [photos objectAtIndex:index];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    return [photos objectAtIndex:index];
}

@end
