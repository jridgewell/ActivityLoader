#import "Example.h"

@implementation Example
@synthesize activityItems;

#pragma mark - Example <ALActivity>

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
    id instance = [Example instance];
    [[ALActivityLoader sharedInstance] registerActivity:instance
                                             identifier:[instance activityType]
                                                  title:[instance activityTitle]];
}

#pragma mark - Example : UIActivity


- (NSString *)activityTitle {
    return NSLocalizedString(@"Example", @"");
}

- (NSString *)activityType {
    return @"name.ridgewell.example";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"icon.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)items {
    self.activityItems = items;
}

- (void)performActivity {
    for (id activityItem in self.activityItems) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self activityTitle]
                                                        message:[NSString stringWithFormat:@"%@", activityItem]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)dealloc {
    [[Example instance] release];
    [super dealloc];
}

@end
