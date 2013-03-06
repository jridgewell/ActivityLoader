//
//  ActivityLoaderHook.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#define CHAppName "ActivityLoaderHook"
#define CHUseSubstrate
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIActivityViewController.h>


CHDeclareClass(UIActivityViewController);

//- (NSArray *)excludedActivityTypes {
CHOptimizedMethod(0, self, NSArray *, UIActivityViewController, excludedActivityTypes) {
    DLog(@"Captain Hooked! %@", self);
    return CHSuper(0, UIActivityViewController, excludedActivityTypes);
}

//- (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities
CHOptimizedMethod(2, self, id, UIActivityViewController, initWithActivityItems, NSArray *, activityItems, applicationActivities, NSArray *, applicationActivities) {
    DLog(@"Captain Hooked! %@", self);
    return nil;
//    return CHSuper(2, UIActivityViewController, initWithActivityItems, activityItems, applicationActivities, applicationActivities);
}

static void LoadSettings() {
    DLog(@"SETTINGS CHANGED");
}

CHConstructor
{
    DLog(@"Loaded CHConstructor");
    CHLoadClass(UIActivityViewController);
    CHHook(0, UIActivityViewController, excludedActivityTypes);
    CHHook(2, UIActivityViewController, initWithActivityItems, applicationActivities);
    //    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)LoadSettings, CFSTR("name.ridgewell.ActivityLoader.settingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}