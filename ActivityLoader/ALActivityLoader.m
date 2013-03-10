//
//  ALActivityLoader.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import "ALActivityLoader.h"
#import <UIKit/UIActivity.h>

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
        __block NSMutableArray *enabledIdentifiers = [NSMutableArray array];
        NSDictionary *activitiesFromPlist = [self activitiesPlist];

        [activitiesFromPlist enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            DLog(@"Checking if %@ should be enabled.", key);
            if ([value boolValue]) {
                id activity = [self.activities objectForKey:key];
                DLog(@"Has %@ registered itself?", key);
                if (activity) {
                    DLog(@"Enabled activity: %@", key);
                    [enabledIdentifiers addObject:key];
                }
            }
        }
        ];
        self.enabledActivityIdentifiers = enabledIdentifiers;
    }

    return self.enabledActivityIdentifiers;
}

- (NSArray *)enabledActivities {
    if (![self.enabledActivities count]) {
        NSMutableArray *enabledActivities = [NSMutableArray array];
        for (NSString *identifier in [self enabledActivityIdentifiers]) {
            [enabledActivities addObject:[self.activities objectForKey:identifier]];
        }

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
    [self.replacedActivities enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
        DLog(@"Did %@ replace %@?", key, activityType);
        if ([enabledActivityIdentifiers containsObject:key]) {
            if ([obj isKindOfClass:[NSString class]]) {
                if ([activityType rangeOfString:obj].location != NSNotFound) {
                    replace = YES;
                }
            } else if ([obj isKindOfClass:[NSRegularExpression class]]) {
                if ([obj numberOfMatchesInString:activityType
                                         options:0
                                           range:NSMakeRange(0, length)] > 0)
                {
                    replace = YES;
                }
            }

            if (replace) {
                DLog(@"%@ replaced %@", key, activityType);
                stop = YES;
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
