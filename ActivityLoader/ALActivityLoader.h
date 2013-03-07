//
//  ALActivityLoader.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@protocol ALActivity;
@class ALActivityLoader;

//extern ALActivityLoader *loader;

@interface ALActivityLoader : NSObject

@property (strong, atomic) NSMutableDictionary *activities;
@property (strong, atomic) NSArray *enabledActivities;
+ (instancetype)sharedInstance;
- (void)registerActivity:(id<ALActivity>)activity forName:(NSString *)name;
- (NSArray *)enabledActivities;

@end
