#import "UniversalLinks.h"

#import <Cordova/CDVAvailability.h>

// #import "CULConfigXmlParser.h"
// #import "CULPath.h"
// #import "CULHost.h"
// #import "CDVPluginResult+CULPlugin.h"
// #import "CDVInvokedUrlCommand+CULPlugin.h"
// #import "CULConfigJsonParser.h"

// @interface UniversalLinks() {
//     NSArray *_supportedHosts;
//     CDVPluginResult *_storedEvent;
//     NSMutableDictionary<NSString *, NSString *> *_subscribers;
// }

// @end

@implementation UniversalLinks

- (void)pluginInitialize {}

- (void)echo:(CDVInvokedUrlCommand *)command {
    NSString* phrase = [command.arguments objectAtIndex:0];
    NSLog(@"%@", phrase);
}

- (void)subscribe:(CDVInvokedUrlCommand *)command {
    NSString* eventName = [command eventName];
    NSLog(@"%@", eventName);

    // if (eventName.length == 0) {
    //     return;
    // }
    
    // _subscribers[eventName] = command.callbackId;
    // [self tryToConsumeEvent];
}

- (void)unsubscribe:(CDVInvokedUrlCommand *)command {
    NSString* eventName = [command eventName];
    NSLog(@"%@", eventName);
    // if (eventName.length == 0) {
    //     return;
    // }
    
    // [_subscribers removeObjectForKey:eventName];
}

@end