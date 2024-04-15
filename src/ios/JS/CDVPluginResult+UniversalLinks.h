#import <Cordova/CDVPlugin.h>
#import "Host.h"

/**
 *  Category to simplify plugin result generation.
 */
@interface CDVPluginResult (UniversalLinks)

/**
 *  Get CDVPluginResult instance with information about the launch url that is send to JS.
 *
 *  @param host        host that corresponds to launch url
 *  @param originalURL launching url
 *
 *  @return instance of the CDVPluginResult
 */
+ (instancetype)resultWithHost:(Host *)host originalURL:(NSURL *)originalURL;

- (BOOL)isResultForEvent:(NSString *)eventName;

- (NSString *)eventName;

@end
