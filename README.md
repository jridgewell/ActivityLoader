ActivityLoader
==============

A library for adding custom UIActions (iOS 6+ share actions) to all apps. **Requires** a jailbroken iOS.
![Instapaper: Read Later using ActivityLoader](https://dl.dropbox.com/u/2924547/activityloader/activityloader.png)

What?
-----

Implementing this library will allow you to add any UIAction to any app that uses UIActivityViewController. That's all the stock Apple apps, right off the bat!
I've implemented Instapaper as an example (using @marianoabdala's [ZYInstapaperActivity](https://github.com/marianoabdala/ZYInstapaperActivity)).


How do I do it?
---------------

    1. Download the [lib and .h files](https://dl.dropbox.com/u/2924547/activityloader/activityloader.zip).
    2. Create a subclass of UIActivity that implements the <ALActivity> protocol.
    3. Do whatever you want.

MyActivity.h
```
#import <UIKit/UIKit.h>
#import <ActivityLoader/ActivityLoader.h>

@interface MyActivity : UIActivity <ALActivity>

@property (strong, atomic) NSArray *activityItems;

// Required by <ALActivity>
+ (instancetype)instance;
+ (instancetype)load;


// Required by UIActivity
- (NSString *)activityType;
- (NSString *)activityTitle;
- (UIImage *)activityImage;
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
- (void)prepareWithActivityItems:(NSArray *)activityItems;
// Implement ONE AND ONLY ONE of the following.
- (UIViewController *)activityViewController;
- (void)performActivity;

@end
```

MyActivity.m
```
#import "MyActivity.h"

@implementation MyActivity

#pragma mark - MyActivity <ALActivity>

+ (instancetype)instance {
    static dispatch_once_t pred = 0;
    __strong static id _instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [self alloc];
        _instance = [_instance init];
    });
    
    return _instance;
}

+ (void)load {
    [[ALActivityLoader sharedInstance] registerActivity:[MyActivity instance]
                                             identifier:[self activityType]
                                                  title:[self activityTitle]];
}

#pragma mark - MyActivity : UIActivity


- (NSString *)activityTitle {
    return NSLocalizedString(@"My Super Cool Share Activity", @"");
}

- (NSString *)activityType {
    return @"com.example.myactivity";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"icon"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityItems = activityItems;
}

- (void)performActivity {
    for (id activityItem in self.activityItems) {
        NSLog(@"%@", activityItem);
    }
}

@end
```


TODO
----

    1. Create an example project.
    2. Create:
        - Theos template
        - iOSOpenDev template
    3. More activities!
