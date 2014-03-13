//
//  ViewController.m
//  Purdue App
//
//  Created by George Lo on 2/24/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    MyPurdueHelper *helper;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Gaussian-Blur Wallpaper using ImageEffects
     * 
     * TODO: use location-based wallpapers from Flickr
     * TODO: compatibility with 64-bit A7 chip
     *
     */
    UIImageView *wallpaperView = [[UIImageView alloc] initWithFrame:self.view.frame];
    UIImage *wallpaperImage = [UIImage imageNamed:@"SampleWallpaper.png"];
    wallpaperView.image = [wallpaperImage applyBlurWithRadius:15 tintColor:[UIColor colorWithWhite:0.98 alpha:0.25] saturationDeltaFactor:1.8 maskImage:nil];
    [self.view addSubview:wallpaperView];
    
    //helper = [[MyPurdueHelper alloc] initWithUser:<#(NSString *)#> AndPassword:<#(NSString *)#>];
    //helper.delegate = self;
}

- (void)completeSchedule:(NSArray *)scheduleArray {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
