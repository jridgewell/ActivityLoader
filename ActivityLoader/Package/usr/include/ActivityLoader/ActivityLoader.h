/* ActivityLoader
 * Copyright (C) 2013 Justin Ridgewell
 */

#import <Foundation/Foundation.h>

@protocol ALActivity <NSObject>

+ (id<ALActivity>)instance;
// +instance is called when injecting your Activity into UIActivityViewController
+ (void)load;
// +load is called as your class enters memory.
// Use this to call registerActivity:identifier:title:

@end

@interface ALActivityLoader : NSObject

+ (instancetype)sharedInstance;
// Returns the single instance of ALActivityLoader in this app
- (void)registerActivity:(id<ALActivity>)activity identifier:(NSString *)identifier title:(NSString *)title;
// Registers your Activity with the loader.
// @param activity   A reference to your Activity's Class
// @param identifier A unique string used to identify your Activity
// @param title      A localized string the user sees in the Settings.app
- (void)identifier:(NSString *)identifier replacesActivity:(id)activity;
// Tells the loader to replace activity with your Activity
// @param identifier The identifier used in registerActivity:identifier:title:
// @param activity   Either an NSString or NSRegularExpression used to identify the activity to replace
//                   If a NSString, anything activityType that contains that string will be replaced
//                   If a NSRegularExpression, activityType strings that return at least one match will be replaced

@end
