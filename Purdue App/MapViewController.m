//
//  MapViewController.m
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    MKMapView *mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    mapView.mapType = [[NSUserDefaults standardUserDefaults] integerForKey:@"MapType"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NoOverlay"]) {
        [mapView removeOverlays:mapView.overlays];
    } else {
        MapOverlay *overlay = [[MapOverlay alloc] initWithRect:MKMapRectMake(40.426526, -86.914559, 4, 4) andCoordinate:CLLocationCoordinate2DMake(40.426526, -86.914559)];
        [mapView addOverlay:overlay];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MapOverlayRenderer *renderer = [[MapOverlayRenderer alloc] initWithOverlay:overlay];
    return renderer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"CAMPUSMAP", nil);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    // Add Search Bar on top of the MapView
    UISearchBar *mapSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, StatusBarHeight+NavBarHeight, ScreenWidth, 44)];
    mapSearchBar.placeholder = NSLocalizedString(@"SEARCH", nil);
    mapSearchBar.showsCancelButton = YES;
    mapSearchBar.delegate = self;
    [self.view addSubview:mapSearchBar];
    
    // Initialize MKMapView with camera centered at Purdue University
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+NavBarHeight+mapSearchBar.frame.size.height, ScreenWidth, self.view.frame.size.height-mapSearchBar.frame.size.height)];
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.426526, -86.914559) fromEyeCoordinate:CLLocationCoordinate2DMake(40.426526, -86.914559) eyeAltitude:3000];
    [mapView setCamera:camera];
    mapView.showsBuildings = YES;
    mapView.showsPointsOfInterest = YES;
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

#pragma mark - Search Bar delegates

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    // Perform Google Search
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
