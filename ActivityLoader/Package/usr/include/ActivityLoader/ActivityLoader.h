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

@end