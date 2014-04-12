//
//  MapOverlay.h
//  Purdue App
//
//  Created by George Lo on 4/8/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapOverlay : NSObject <MKOverlay>

- (instancetype)initWithRect: (MKMapRect)mapRect andCoordinate: (CLLocationCoordinate2D)coord;


@end
