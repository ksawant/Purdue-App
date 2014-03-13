//
//  MyPurdueHelper.h
//  Purdue App
//
//  Created by George Lo on 2/25/14.
//  Copyright (c) 2014 Purdue iOS Development Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyPurdueHelperDelegate;

@interface MyPurdueHelper : NSObject <UIWebViewDelegate>

@property (nonatomic, weak) id<MyPurdueHelperDelegate> delegate;

- (id)initWithUser: (NSString *)username AndPassword: (NSString *)password;

@end

@protocol MyPurdueHelperDelegate <NSObject>

@optional
- (void)completeSchedule: (NSArray *)scheduleArray;

@end
