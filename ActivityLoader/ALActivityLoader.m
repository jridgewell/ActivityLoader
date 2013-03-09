//
//  ALActivityLoader.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import "ALActivityLoader.h"

@implementation ALActivityLoader
@dynamic enabledActivities, activitiesPlist;

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [self alloc];
        instance = [instance init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
		self.activities = [NSMutableDictionary dictionary];
		self.activityTitles = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerActivity:(id<ALActivity>)activity identifier:(NSString *)identifier title:(NSString *)title {
    DLog(@"Activity: %@, ID: %@, title: %@", activity, identifier, title);
    [self.activities setObject:activity forKey:identifier];
    [self.activityTitles setObject:title forKey:identifier];
}

- (NSArray *)enabledActivities {
    if (self.enabledActivities) {
        __block NSMutableArray *enabledActivities = [NSMutableArray array];
        
        NSDictionary *activitiesFromPlist = [self activitiesPlist];
        [activitiesFromPlist enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if ([value boolValue]) {
                id activity = [self.activities objectForKey:key];
                if (activity) {
                    [enabledActivities addObject:activity];
                }
            }
        }];
        QLog(enabledActivities);
        self.enabledActivities = enabledActivities;
    }
    
    return self.enabledActivities;
}

- (NSDictionary *)activitiesPlist {
    // TODO: Implement method to reread plist on app exit
    if (!self.activitiesPlist) {
        self.activitiesPlist = [NSDictionary dictionaryWithContentsOfFile:kPrefs_File];
    }
    return self.activitiesPlist;
}
@end
