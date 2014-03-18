//
//  Album.h
//  Purdue App
//
//  Created by George Lo on 3/16/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (nonatomic) UIImage *thumbnail;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *numPhotos;
@property (nonatomic) NSString *urlString;

@end
