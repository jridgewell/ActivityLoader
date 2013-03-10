//
//  ALActivityLoader.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#define kAL_ID @"name.ridgewell.activityloader"
#define kActivities_Path @"/Library/ActivityLoader/"
#define kPrefs_Path @"/var/mobile/Library/Preferences/"
#define kPrefs_File kPrefs_Path kAL_ID @".plist"

#import "ActivityLoader.h"

@class UIActivity;
@interface ALActivityLoader ()

@property (strong, atomic) NSMutableDictionary *activities;
@property (strong, atomic) NSMutableDictionary *activityTitles;
@property (strong, atomic) NSMutableDictionary *replacedActivities;
@property (strong, atomic, getter = getEnabledActivities) NSArray *enabledActivities;
@property (strong, atomic, getter = getEnabledActivityIdentifiers) NSArray *enabledActivityIdentifiers;
@property (strong, atomic, getter = getActivitiesPlist) NSDictionary *activitiesPlist;
- (NSArray *)enabledActivities;
- (NSArray *)enabledActivityIdentifiers;
- (NSDictionary *)activitiesPlist;
- (BOOL)activityIsReplaced:(UIActivity *)activity;
- (void)cacheBust;

@end
