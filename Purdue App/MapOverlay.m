//
//  MapOverlay.m
//  Purdue App
//
//  Created by George Lo on 4/8/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "MapOverlay.h"

@implementation MapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithRect: (MKMapRect)mapRect andCoordinate: (CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        boundingMapRect = mapRect;
        coordinate = coord;
    }
    
    return self;
}


@end
