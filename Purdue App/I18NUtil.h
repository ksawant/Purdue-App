//
//  I18NUtil.h
//  Campus Bus
//
//  Created by George Lo on 3/9/14.
//  Copyright (c) 2014 George Lo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface I18NUtil : NSObject

+ (void)initialize;
+ (void)setLanguage:(NSString *)languageCode;
+ (NSString *)localizedString:(NSString *)key;

@end
