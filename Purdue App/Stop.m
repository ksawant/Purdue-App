//
//  Stop.m
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import "Stop.h"

@implementation Stop

@synthesize Id;
@synthesize name;
@synthesize description;
@synthesize coordinate;
@synthesize buddy;
@synthesize announce;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.Id = [aDecoder decodeIntegerForKey:@"Id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.coordinate = CLLocationCoordinate2DMake([aDecoder decodeFloatForKey:@"latitude"], [aDecoder decodeFloatForKey:@"longitude"]);
        self.buddy = [aDecoder decodeIntegerForKey:@"buddy"];
        self.announce = [aDecoder decodeBoolForKey:@"announce"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:Id forKey:@"Id"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeFloat:coordinate.latitude forKey:@"latitude"];
    [aCoder encodeFloat:coordinate.longitude forKey:@"longitude"];
    [aCoder encodeInteger:buddy forKey:@"buddy"];
    [aCoder encodeBool:announce forKey:@"announce"];
}

@end
