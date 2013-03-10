//
//  ActivityLoaderController.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "ALPreferenceController.h"

@implementation ALPreferenceController

- (id)getValueForSpecifier:(PSSpecifier *)specifier {
    id value = nil;
    NSDictionary *specifierProperties = [specifier properties];
    NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key] ? : nil;
    NSString *plistPath = [specifierProperties objectForKey:kPrefs_KeyName_Defaults] ? : kAL_ID;

    if (specifierKey) {
        NSDictionary *dict = [ALPreferenceController dictionaryWithFile:&plistPath asMutable:NO];
        id objectValue = [dict objectForKey:specifierKey];
        if (objectValue) {
            value = [NSString stringWithFormat:@"%@", objectValue];
            DLog(@"read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
        } else {
            DLog(@"key '%@' not found in plist '%@'", specifierKey, plistPath);
        }
    }

    return value;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier; {
    NSDictionary *specifierProperties = [specifier properties];
    NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
    NSString *plistPath = [specifierProperties objectForKey:kPrefs_KeyName_Defaults] ? : kAL_ID;

    if (specifierKey) {
        NSMutableDictionary *dict = [ALPreferenceController dictionaryWithFile:&plistPath asMutable:YES];
        [dict setObject:value forKey:specifierKey];
        [dict writeToFile:plistPath atomically:YES];
        DLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
    }
}

- (id)specifiers {
    if (_specifiers == nil) {
        NSMutableArray *specifiers = [NSMutableArray array];
        ALActivityLoader *loader = [ALActivityLoader sharedInstance];

        for (NSString *key in loader.activities) {
            DLog(@"Processing Specifier %@", key);
            __block PSSpecifier *specifier;
            specifier = [PSSpecifier preferenceSpecifierNamed:[loader.activityTitles objectForKey:key]
                                                       target:self
                                                          set:@selector(setValue:forSpecifier:)
                                                          get:@selector(getValueForSpecifier:)
                                                       detail:nil
                                                         cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"]
                                                         edit:nil];
            [specifier setProperty:key forKey:kPrefs_KeyName_Key];
            [specifier setProperty:kAL_ID forKey:kPrefs_KeyName_Defaults];

            BOOL (^checkForSameSpecifier)(id, NSUInteger, BOOL *) = ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
                NSComparisonResult check = [[obj identifier] compare:[specifier identifier]];
                return (check == NSOrderedSame);
            };
            NSUInteger indexOfSameSpecifier = [specifiers indexOfObjectPassingTest:checkForSameSpecifier];
            BOOL specifierAlreadyExists = (indexOfSameSpecifier != NSNotFound);
            if (!specifierAlreadyExists) {
                [specifiers addObject:specifier];
            }
        }

        _specifiers = specifiers;
    }

    return _specifiers;
}

+ (id)dictionaryWithFile:(NSString **)plistPath asMutable:(BOOL)asMutable {
    Class class = (asMutable) ? [NSMutableDictionary class] :[NSDictionary class];
    id dict;

    if ([*plistPath hasPrefix : @"/"]) {
        *plistPath = [NSString stringWithFormat:@"%@.plist", *plistPath];
    } else {
        *plistPath = [NSString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath]) {
        dict = [class dictionaryWithContentsOfFile:*plistPath];
    } else {
        dict = [class dictionary];
    }

    return dict;
}

@end
