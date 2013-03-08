//
//  ActivityLoader.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@class ALActivityLoader;

@protocol ALActivity <NSObject>

+ (id<ALActivity>)instance;
+ (void)load;

@end

@interface ALActivityLoader : NSObject

+ (instancetype)sharedInstance;
- (void)registerActivity:(id<ALActivity>)activity identifier:(NSString *)identifier title:(NSString *)title;

@end