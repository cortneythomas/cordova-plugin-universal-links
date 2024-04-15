#import <Cordova/CDVPlugin.h>

/**
 *  Category to get the event name from the request, that is sent from JS side.
 */
@interface CDVInvokedUrlCommand (UniversalLinks)

/**
 *  Get event name from JS request.
 *
 *  @return event name
 */
- (NSString *)eventName;

@end
