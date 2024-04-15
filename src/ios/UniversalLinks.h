// #import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

/**
 *  Plugin main class.
 */
@interface UniversalLinks : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand *)command;
- (void)subscribe:(CDVInvokedUrlCommand *)command;
- (void)unsubscribe:(CDVInvokedUrlCommand *)command;
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity;

@end

