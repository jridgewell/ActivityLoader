//
//  ActivityLoader.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@protocol ActivityLoader <NSObject>

- (NSString *)activityType;
- (NSString *)activityTitle;
- (UIImate *)activityImage;
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
- (void)prepareWithActivityItems:(NSArray *)activityItems;
- (void)performActivity;

@end
