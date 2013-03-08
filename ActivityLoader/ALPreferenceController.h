//
//  ActivityLoaderController.h
//  ActivityLoader
//
//  Created by Justin Ridgewell on 3/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Preferences/PSListController.h>
#import "ALActivityLoader.h"

@class PSListController;

@interface ALPreferenceController : PSListController

- (id)getValueForSpecifier:(PSSpecifier *)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier;

@end
