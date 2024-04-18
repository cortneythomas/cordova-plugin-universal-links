#import "AppDelegate.h"
#import "UniversalLinks.h"

static NSString *const PLUGIN_NAME = @"UniversalLinks";

@implementation AppDelegate (UniversalLinks)

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    NSLog(@"Cortney in app delegate one: %@", userActivity.webpageURL);
    NSLog(@"Cortney in app delegate two: %@", userActivity.activityType);
    NSLog(@"Cortney in app delegate three: %@", userActivity.targetContentIdentifier);
    // ignore activities that are not for Universal Links
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb] || userActivity.webpageURL == nil) {
        return NO;
    }

    // get instance of the plugin and let it handle the userActivity object
    UniversalLinks *plugin = [self.viewController getCommandInstance:PLUGIN_NAME];
    if (plugin == nil) {
        return NO;
    }

    return [plugin handleUserActivity:userActivity];
}

@end
