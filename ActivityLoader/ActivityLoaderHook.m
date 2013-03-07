//
//  ActivityLoaderHook.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#define APP_ID @"name.ridgewell.ActivityLoader"
#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/"
#define PREFERENCES_FILE PREFERENCES_PATH APP_ID @".plist"
#define READING_LIST_ACTIVITY_TYPE @"com.apple.mobilesafari.activity.addToReadingList"
#define ACTIVITIES_PATH @"/Library/ActivityLoader/"

#define CHAppName "ActivityLoaderHook"
#define CHUseSubstrate
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIActivityViewController.h>
#import <dlfcn.h>
#import "ALActivityLoader.h"


#pragma mark - UIActivityViewController Hook

CHDeclareClass(UIActivityViewController);
// - (NSArray *)excludedActivityTypes {
CHOptimizedMethod(0, self, NSArray *, UIActivityViewController, excludedActivityTypes) {
    return CHSuper(0, UIActivityViewController, excludedActivityTypes);
}

// - (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities
CHOptimizedMethod(2, self, id, UIActivityViewController, initWithActivityItems, NSArray *, activityItems, applicationActivities, NSArray *, applicationActivities) {
    ALActivityLoader *loader = [ALActivityLoader sharedInstance];
    NSMutableArray *activities = [NSMutableArray arrayWithArray:applicationActivities];
    QLog(loader);
//    QLog([loader enabledActivities]);
    
	for (id<ALActivity> activity in loader.enabledActivities) {
//        QLog(activity);
		[activities addObject:activity];
	}
    QLog(activities);
    return nil; //CHSuper(2, UIActivityViewController, initWithActivityItems, activityItems, applicationActivities, activities);
}

CHConstructor {
    DLog(@"Loaded CHConstructor");
    CHLoadClass(UIActivityViewController);
    CHHook(0, UIActivityViewController, excludedActivityTypes);
    CHHook(2, UIActivityViewController, initWithActivityItems, applicationActivities);
}
