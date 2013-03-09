#import <UIKit/UIKit.h>
#import <ActivityLoader/ActivityLoader.h>

@interface @@PROJECTNAME@@ : UIActivity <ALActivity>

@property (retain) NSArray *activityItems;

// Required by <ALActivity>
+ (instancetype)instance;
+ (void)load;


// Required by UIActivity
- (NSString *)activityType;
- (NSString *)activityTitle;
- (UIImage *)activityImage;
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;
- (void)prepareWithActivityItems:(NSArray *)items;
// Implement ONE AND ONLY ONE of the following.
// - (UIViewController *)activityViewController;
- (void)performActivity;

@end
