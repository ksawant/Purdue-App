//
//  Route.h
//  Purdue App
//
//  Created by George Lo on 3/12/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *short_name;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *color;
@property (nonatomic) NSString *schedule;
@property (nonatomic) BOOL active;
@property (nonatomic) NSArray *path;
@property (nonatomic) NSArray *stops;

@end
