//
//  ActivityLoaderController.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ALPreferenceController.h"
#import "ALActivityLoader.h"
#import <Preferences/PSSpecifier.h>

#define kActivity_Path @"/Library/ActivityLoader/"
#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

@implementation ALPreferenceController

- (id)getValueForSpecifier:(PSSpecifier *)specifier {
    id value = nil;
    NSDictionary *specifierProperties = [specifier properties];
    NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key] ? : nil;
    NSString *plistPath = [specifierProperties objectForKey:kPrefs_KeyName_Defaults] ? : APP_ID;

    DLog(@"%@", specifierKey);
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
    NSString *plistPath = [specifierProperties objectForKey:kPrefs_KeyName_Defaults] ? : APP_ID;

    DLog(@"%@", specifierKey);
    if (specifierKey) {
        NSMutableDictionary *dict = [ALPreferenceController dictionaryWithFile:&plistPath asMutable:YES];
        [dict setObject:value forKey:specifierKey];
        [dict writeToFile:plistPath atomically:YES];
        DLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);

        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("name.ridgewell.ActivityLoader.settingsChanged"), NULL, NULL, YES);
    }
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

- (id)specifiers {
    if (_specifiers == nil) {
        id specifiers = [self loadSpecifiersFromPlistName:@"ActivityLoader" target:self];
        ALActivityLoader *loader = [ALActivityLoader sharedInstance];
//        extern ALActivityLoader *loader;
        QLog(loader);
        QLog(loader.activities);
//        NSArray *extensions = @[@"dylib", @"bundle"];
//        NSArray *subpaths = [self subpathsOfDirectoryAtPath:kActivity_Path ofType:extensions];
//        
//        for (NSString *item in subpaths) {
//            DLog(@"processing %@", item);
//            //        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", kActivity_Path, item];
//            __block PSSpecifier *specifier;
//            switch ([extensions indexOfObject:[item pathExtension]]) {
//                case 0:
//                    specifier = [PSSpecifier preferenceSpecifierNamed:[item stringByDeletingPathExtension]
//                                                               target:self
//                                                                  set:@selector(setValue:forSpecifier:)
//                                                                  get:@selector(getValueForSpecifier:)
//                                                               detail:nil
//                                                                 cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"]
//                                                                 edit:nil];
//                    [specifier setProperty:[item stringByDeletingPathExtension] forKey:kPrefs_KeyName_Key];
//                    [specifier setProperty:APP_ID forKey:kPrefs_KeyName_Defaults];
//                    [specifier setProperty:@"name.ridgewell.ActivityLoader.settingsChanged" forKey:@"PostNotification"];
//                    break;
//                case 1:
//                    
//                    break;
//            }
//            
//            BOOL (^checkForSameSpecifier)(id, NSUInteger, BOOL *) = ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
//                NSComparisonResult check = [[obj identifier] compare:[specifier identifier]];
//                return (check == NSOrderedSame);
//            };
//            NSUInteger indexOfSameSpecifier = [specifiers indexOfObjectPassingTest:checkForSameSpecifier];
//            BOOL specifierAlreadyExists = (indexOfSameSpecifier != NSNotFound);
//            if (!specifierAlreadyExists) {
//                [specifiers addObject:specifier];
//            }
//        }
        
        for (NSString *key in loader.activities) {
            DLog(@"processing %@", key);
            __block PSSpecifier *specifier;
            specifier = [PSSpecifier preferenceSpecifierNamed:[key pathExtension]
                                                       target:self
                                                          set:@selector(setValue:forSpecifier:)
                                                          get:@selector(getValueForSpecifier:)
                                                       detail:nil
                                                         cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"]
                                                         edit:nil];
            [specifier setProperty:key forKey:kPrefs_KeyName_Key];
            [specifier setProperty:APP_ID forKey:kPrefs_KeyName_Defaults];
            [specifier setProperty:@"name.ridgewell.ActivityLoader.settingsChanged" forKey:@"PostNotification"];
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

- (NSArray *)subpathsOfDirectoryAtPath:(NSString *)directory ofType:(NSArray *)extensions {
    __block NSArray *ext = extensions;
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directory error:nil];
    
    BOOL (^filterPathsWithExtension)(id, NSDictionary *) = ^BOOL (id evaluatedObject, NSDictionary *bindings) {
        return [ext containsObject:[evaluatedObject pathExtension]];
    };
    NSPredicate *predicate = [NSPredicate predicateWithBlock:filterPathsWithExtension];
    
    subpaths = [subpaths filteredArrayUsingPredicate:predicate];
    return subpaths;
}

- (id)init {
    if (self = [super init]) {
    }

    return self;
}

@end
