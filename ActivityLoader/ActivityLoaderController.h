//
//  ActivityLoaderController.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

#define APP_ID "name.ridgewell.ActivityLoader"

@interface ActivityLoaderController : PSListController

- (id)getValueForSpecifier:(PSSpecifier *)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier;

@end
