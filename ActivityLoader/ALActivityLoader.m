//
//  ALActivityLoader.m
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import "ALActivityLoader.h"

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

- (instancetype)init {
    if (self = [super init]) {
		self.activities = [NSMutableDictionary dictionary];
		self.activityTitles = [NSMutableDictionary dictionary];
		self.enabledActivities = [NSMutableArray array];
    }
    return self;
}

- (void)registerActivity:(id<ALActivity>)activity identifier:(NSString *)identifier title:(NSString *)title {
    DLog(@"Activity: %@, ID: %@, title: %@", activity, identifier, title);
    [self.activities setObject:activity forKey:identifier];
    [self.activityTitles setObject:title forKey:identifier];
}

- (NSArray *)enabledActivities {
    if (![self._enabledActivities count]) {
        NSDictionary *activitiesFromPlist = [NSDictionary dictionaryWithContentsOfFile:kPrefs_File];
        __block NSMutableArray *enabledActivities = [NSMutableArray array];
        
        [activitiesFromPlist enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if ([value boolValue]) {
                id activity =[self.activities objectForKey:key];
                if (activity) {
                    [enabledActivities addObject:activity];
                }
            }
        }];
        QLog(enabledActivities);
        self._enabledActivities = enabledActivities;
    }
    
    return self._enabledActivities;
}

@end
