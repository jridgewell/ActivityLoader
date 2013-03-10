//
//  ALActivityLoader.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import "ALActivityLoader.h"
#import <UIKit/UIActivity.h>
#import "NSArray+Funcussion.h"
#import "NSDictionary+Funcussion.h"

@implementation ALActivityLoader

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id instance = nil;

    dispatch_once(&pred, ^{
        instance = [self alloc];
        instance = [instance init];
    }
                  );
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.activities = [NSMutableDictionary dictionary];
        self.activityTitles = [NSMutableDictionary dictionary];
        self.replacedActivities = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)registerActivity:(id<ALActivity>)activity identifier:(NSString *)identifier title:(NSString *)title {
    DLog(@"Activity: %@, ID: %@, title: %@", activity, identifier, title);
    [self.activities setObject:activity forKey:identifier];
    [self.activityTitles setObject:title forKey:identifier];
}

- (void)identifier:(NSString *)identifier replacesActivity:(id)activity {
    DLog(@"Replace Activity: %@, with: %@", activity, identifier);
    [self.replacedActivities setObject:activity forKey:identifier];
}

- (NSArray *)enabledActivityIdentifiers {
    if (![self.enabledActivityIdentifiers count]) {
        QLog(@"Initializing enabled activities");
        __block NSDictionary *activities = self.activities;
        NSDictionary *activitiesFromPlist = [self activitiesPlist];
        
        NSArray *enabledIdentifiers = [[activitiesFromPlist filter:^BOOL(id identifier, id enabled) {
            DLog(@"Checking if %@ should be enabled.", identifier);
            return ([enabled boolValue] && [activities objectForKey:identifier]);
        }] mapToArray:^id(id identifier, id enabled) {
            DLog(@"Enabled activity: %@", identifier);
            return identifier;
        }];
        
        self.enabledActivityIdentifiers = enabledIdentifiers;
    }

    return self.enabledActivityIdentifiers;
}

- (NSArray *)enabledActivities {
    if (![self.enabledActivities count]) {
        __block NSDictionary *activities = self.activities;
        __block NSArray *enabledIdentifiers = [self enabledActivityIdentifiers];
        NSArray *enabledActivities = [enabledIdentifiers map:^id(id identifier) {
            return [activities objectForKey:identifier];
        }];

        self.enabledActivities = enabledActivities;
    }

    return self.enabledActivities;
}

- (NSDictionary *)activitiesPlist {
    // TODO: Implement method to reread plist on app exit
    if (![self.activitiesPlist count]) {
        QLog(@"Loading Activities Plist");
        self.activitiesPlist = [NSDictionary dictionaryWithContentsOfFile:kPrefs_File];
    }

    return self.activitiesPlist;
}

- (BOOL)activityIsReplaced:(UIActivity *)activity {
    __block BOOL replace = NO;
    __block NSString *activityType = [activity activityType];
    __block NSUInteger length = [activityType length];
    __block NSArray *enabledActivityIdentifiers = [self enabledActivityIdentifiers];

    DLog(@"Checking if %@ has been replaced", activityType);
    [self.replacedActivities enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id identifier, id pattern, BOOL *stop) {
        if ([enabledActivityIdentifiers containsObject:identifier]) {
            DLog(@"Did %@ replace %@?", identifier, activityType);
            if ([pattern isKindOfClass:[NSString class]]) {
                pattern = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                    options:NSRegularExpressionIgnoreMetacharacters
                                                                      error:NULL];
            }
            if ([pattern isKindOfClass:[NSRegularExpression class]]) {
                NSUInteger numMatches = [pattern numberOfMatchesInString:activityType
                                                                 options:0
                                                                   range:NSMakeRange(0, length)];
                if (numMatches > 0) {
                    DLog(@"%@ replaced %@", identifier, activityType);
                    replace = YES;
                    stop = YES;
                }
            }
        }
    }
    ];
    return replace;
}

- (void)cacheBust {
    self.activitiesPlist = nil;
    self.enabledActivities = nil;
    self.enabledActivityIdentifiers = nil;
}

@end
