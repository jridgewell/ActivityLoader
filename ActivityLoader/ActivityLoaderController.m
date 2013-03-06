//
//  ActivityLoaderController.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ActivityLoaderController.h"
#import <Preferences/PSSpecifier.h>

#define kActivity_Path @"/Library/ActivityLoader/"
#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

@implementation ActivityLoaderController

- (id)getValueForSpecifier:(PSSpecifier *)specifier {
    id value = nil;
    NSDictionary *specifierProperties = [specifier properties];
    NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key] ? : nil;
    NSString *plistPath = [specifierProperties objectForKey:kPrefs_KeyName_Defaults] ? : @APP_ID;

    DLog(@"%@", specifierKey);
    if (specifierKey) {
        NSDictionary *dict = [self dictionaryWithFile:&plistPath asMutable:NO];
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
    NSString *plistPath = [specifierProperties objectForKey:kPrefs_KeyName_Defaults] ? : @APP_ID;

    DLog(@"%@", specifierKey);
    if (specifierKey) {
        NSMutableDictionary *dict = [self dictionaryWithFile:&plistPath asMutable:YES];
        [dict setObject:value forKey:specifierKey];
        [dict writeToFile:plistPath atomically:YES];

        DLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
    }
}

- (id)dictionaryWithFile:(NSString **)plistPath asMutable:(BOOL)asMutable {
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

- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self generateSpecifiersFromDirectory:kActivity_Path];
    }

    return _specifiers;
}

- (id)generateSpecifiersFromDirectory:(NSString *)directory {
    id specifiers = [self loadSpecifiersFromPlistName:@"ActivityLoader" target:self];
    NSArray *extensions = @[@"dylib", @"bundle"];
    NSArray *subpaths = [self subpathsOfDirectoryAtPath:directory ofType:extensions];

    for (NSString *item in subpaths) {
        DLog(@"processing %@", item);
//        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", kActivity_Path, item];
        __block PSSpecifier *specifier;
        switch ([extensions indexOfObject:[item pathExtension]]) {
            case 0:
                specifier = [PSSpecifier preferenceSpecifierNamed:[[item stringByDeletingPathExtension] pathExtension]
                                                           target:self
                                                              set:@selector(setValue:forSpecifier:)
                                                              get:@selector(getValueForSpecifier:)
                                                           detail:nil
                                                             cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"]
                                                             edit:nil];
                break;
            case 1:

                break;
        }

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

#ifdef DEBUG
    [specifiers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DLog(@"%@", obj);
        DLog(@"Name: %@", [obj name]);
        DLog(@"Identifier: %@", [obj identifier]);
        DLog(@"Target: %@", [obj target]);
        DLog(@"Properties: %@", [obj properties]);
        DLog(@"Controller: %@", [obj detailControllerClass]);
        DLog(@"Cell: %d", [obj cellType]);
        DLog(@"Edit: %@", [obj editPaneClass]);
    }
    ];
#endif /* ifdef DEBUG */
    return specifiers;
}

- (id)init {
    if (self = [super init]) {
    }

    return self;
}

@end
