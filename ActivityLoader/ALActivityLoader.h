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

@interface ALActivityLoader ()

@property (strong, atomic) NSMutableDictionary *activities;
@property (strong, atomic) NSMutableDictionary *activityTitles;
@property (strong, atomic, getter = getEnabledActivities, setter = setEnabledActivities:) NSArray *enabledActivities;
@property (strong, atomic, getter = getActivitiesPlist, setter = setActivitiesPlist:) NSDictionary *activitiesPlist;
- (NSArray *)enabledActivities;
- (NSDictionary *)activitiesPlist;

@end
