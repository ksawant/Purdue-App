//
//  MapOverlayRenderer.m
//  Purdue App
//
//  Created by George Lo on 4/9/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "MapOverlayRenderer.h"

@implementation MapOverlayRenderer

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    UIImage *image = [UIImage imageNamed:@"Buildings"];
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    
    CGContextDrawImage(context, theRect, imageReference);
}

@end
