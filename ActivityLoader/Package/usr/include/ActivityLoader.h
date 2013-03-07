//
//  ActivityLoader.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@class ALActivityLoader;
extern ALActivityLoader *loader;

@protocol ALActivity <NSObject>

+ (id<ALActivity>)instance;
+ (void)load;

@end

@interface ALActivityLoader : NSObject

+ (instancetype)sharedInstance;
- (void)registerActivity:(id<ALActivity>)activity forName:(NSString *)name;

@end