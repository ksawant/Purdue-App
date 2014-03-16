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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Purdue Map";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    // Add Search Bar on top of the MapView
    UISearchBar *mapSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, StatusBarHeight+NavBarHeight, ScreenWidth, 44)];
    mapSearchBar.placeholder = @"Search";
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
