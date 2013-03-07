//
//  ALActivityLoader.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import "ALActivityLoader.h"
#import <dlfcn.h>

//ALActivityLoader *loader;// = [ALActivityLoader sharedInstance];

static void SettingsChanged() {
    DLog(@"SETTINGS CHANGED");
    ALActivityLoader *loader = [ALActivityLoader sharedInstance];
    QLog(loader);
    NSDictionary *activitiesFromPlist = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/name.ridgewell.ActivityLoader.plist"];
    __block NSMutableArray *enabledActivities = [NSMutableArray array];
    
    [activitiesFromPlist enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([value boolValue]) {
            [enabledActivities addObject:[loader.activities objectForKey:key]];
        }
    }];
    QLog(enabledActivities);
    
//    loader.enabledActivities = enabledActivities;
}


@implementation ALActivityLoader

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [self alloc];
        instance = [instance init];
    });
    return instance;
}

//- (NSMutableArray *)enabledActivities {
//    __block NSMutableArray *activities = [NSMutableArray array];
//
//    NSDictionary *activitiesFromPlist = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/name.ridgewell.ActivityLoader.plist"];
//    
//    [activitiesFromPlist enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
//        if ([value boolValue]) {
//            NSString *path = [NSString stringWithFormat:@"/Library/ActivityLoader/%@.dylib", key];
//            QLog(path);
//            void *handle = dlopen("/Library/ActivityLoader/%@.dylib", RTLD_LOCAL|RTLD_NOW);
//            QLog(handle);
//            if (handle) {
//                void (*load)() = dlsym(handle, "load");
//                if (load) {
//                    QLog(@"LOAD");
//                    load();
//                } else {
//                    QLog(@"NOLOAD!");
//                }
//            } else {
//                QLog(@"NOHANDLE!");
//            }
////            NSBundle *bundle = [NSBundle bundleWithPath:path];
////            QLog(bundle);
////            if (bundle) {
////                Class class = [bundle principalClass];
////                QLog(class);
////                if (class) {
////                    [activities addObject:[[class alloc] init]];
////                }
////            }
//        }
//    }];
//    QLog(activities);
//    return activities;
//}

- (instancetype)init {
    if (self = [super init]) {
		self.activities = [NSMutableDictionary dictionary];
		self.enabledActivities = [NSMutableArray array];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &SettingsChanged, CFSTR("name.ridgewell.ActivityLoader.settingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
    return self;
}

- (void)registerActivity:(id<ALActivity>)activity forName:(NSString *)name {
    [self.activities setObject:activity forKey:name];
}

@end
