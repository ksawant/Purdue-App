//
//  I18NUtil.m
//  Campus Bus
//
//  Created by George Lo on 3/9/14.
//  Copyright (c) 2014 George Lo. All rights reserved.
//

#import "I18NUtil.h"

@implementation I18NUtil

static NSBundle *_bundle;
static NSString *_language;

+ (void)initialize
{
    [self setLanguage:[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]];
}

+ (void)setLanguage:(NSString *)languageCode
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:languageCode, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
    _bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)localizedString:(NSString *)key
{
    return [_bundle localizedStringForKey:key value:@"" table:nil];
}

@end
