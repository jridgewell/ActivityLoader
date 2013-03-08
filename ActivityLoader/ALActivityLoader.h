//
//  ALActivityLoader.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#define kAL_ID @"name.ridgewell.ActivityLoader"
#define kActivities_Path @"/Library/ActivityLoader/"
#define kPrefs_Path @"/var/mobile/Library/Preferences/"
#define kPrefs_File kPrefs_Path kAL_ID @".plist"

@protocol ALActivity;
@class ALActivityLoader;

@interface ALActivityLoader : NSObject

@property (strong, atomic) NSMutableDictionary *activities;
@property (strong, atomic) NSMutableDictionary *activityTitles;
@property (strong, atomic, getter = getEnabledActivities, setter = setEnabledActivities:) NSArray *_enabledActivities;
+ (instancetype)sharedInstance;
- (void)registerActivity:(id<ALActivity>)activity identifier:(NSString *)identifier title:(NSString *)title;
- (NSArray *)enabledActivities;

@end
