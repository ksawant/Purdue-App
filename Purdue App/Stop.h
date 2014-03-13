//
//  Stop.h
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stop : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *description;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSInteger buddy;
@property (nonatomic) BOOL announce;

@end
