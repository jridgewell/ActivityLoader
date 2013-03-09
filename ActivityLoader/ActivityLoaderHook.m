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
#import "ALActivityLoader.h"


#pragma mark - UIActivityViewController Hook

CHDeclareClass(UIActivityViewController);
// - (NSArray *)excludedActivityTypes {
CHOptimizedMethod(0, self, NSArray *, UIActivityViewController, excludedActivityTypes) {
    QLog(@"Excluded Activity Types");
    return CHSuper(0, UIActivityViewController, excludedActivityTypes);
}

// - (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities
CHOptimizedMethod(2, self, id, UIActivityViewController, initWithActivityItems, NSArray *, activityItems, applicationActivities, NSArray *, applicationActivities) {
    ALActivityLoader *loader = [ALActivityLoader sharedInstance];
    NSArray *enabledActivities = [loader enabledActivities];
    NSMutableArray *activities = [NSMutableArray arrayWithArray:applicationActivities];
    DLog(@"Got these activities: %@", activities);
    
	for (id<ALActivity> activity in enabledActivities) {
		[activities addObject:activity];
	}
    return CHSuper(2, UIActivityViewController, initWithActivityItems, activityItems, applicationActivities, activities);
}

CHConstructor {
    DLog(@"Loaded Hooker");
    CHLoadClass(UIActivityViewController);
    CHHook(0, UIActivityViewController, excludedActivityTypes);
    CHHook(2, UIActivityViewController, initWithActivityItems, applicationActivities);
}
