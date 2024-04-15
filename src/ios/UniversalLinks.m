#import "UniversalLinks.h"

#import <Cordova/CDVAvailability.h>

#import "UniversalLinks.h"
#import "XmlParser.h"
#import "Path.h"
#import "Host.h"
#import "CDVPluginResult+UniversalLinks.h"
#import "CDVInvokedUrlCommand+UniversalLinks.h"
#import "JsonParser.h"

@interface UniversalLinks() {
    NSArray *_supportedHosts;
    CDVPluginResult *_storedEvent;
    NSMutableDictionary<NSString *, NSString *> *_subscribers;
}

@end

@implementation UniversalLinks

- (void)pluginInitialize {
    [self localInit];
}

- (void)onAppTerminate {
    _supportedHosts = nil;
    _subscribers = nil;
    _storedEvent = nil;

    [super onAppTerminate];
}

- (void)echo:(CDVInvokedUrlCommand *)command {
    NSString* phrase = [command.arguments objectAtIndex:0];
    NSLog(@"Cortney echo: %@", phrase);
}

/**
 *  Find host entry that corresponds to launch url.
 *
 *  @param  launchURL url that launched the app
 *  @return host entry; <code>nil</code> if none is found
 */
- (Host *)findHostByURL:(NSURL *)launchURL {
  NSLog(@"Cortney findHostByURL: %@", launchURL);
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:launchURL resolvingAgainstBaseURL:YES];
    Host *host = nil;
    for (Host *supportedHost in _supportedHosts) {
        NSLog(@"Cortney each host in supported host: %@", supportedHost.name);
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self LIKE[c] %@", supportedHost.name];
        if ([pred evaluateWithObject:urlComponents.host]) {
            host = supportedHost;
            break;
        }
    }

    return host;
}

- (NSArray<Host *> *)getSupportedHostsFromPreferences {
  
    NSString *jsonConfigPath = [[NSBundle mainBundle] pathForResource:@"ul" ofType:@"json" inDirectory:@"www"];
    NSLog(@"Cortney jsonConfigPath in getSupportedHostsFromPreferences: %@", jsonConfigPath);
    if (jsonConfigPath) {
        return [JsonParser parseConfig:jsonConfigPath];
    }

    return [XmlParser parse];
}

- (void)handleOpenURL:(NSNotification*)notification {
  NSLog(@"Cortney handleOpenURL: %@", notification.object);
    id url = notification.object;
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }

    Host *host = [self findHostByURL:url];
    if (host) {
        [self storeEventWithHost:host originalURL:url];
    }
}

- (void)localInit {
  NSLog(@"Cortney localInit: %@", _supportedHosts);
    if (_supportedHosts) {
        return;
    }

    _subscribers = [[NSMutableDictionary alloc] init];

    // Get supported hosts from the config.xml or www/ul.json.
    // For now priority goes to json config.
    _supportedHosts = [self getSupportedHostsFromPreferences];
}

/**
 *  Store event data for future use.
 *  If we are resuming the app - try to consume it.
 *
 *  @param host        host that matches the launch url
 *  @param originalUrl launch url
 */
- (void)storeEventWithHost:(Host *)host originalURL:(NSURL *)originalUrl {
  NSLog(@"Cortney storeEventWithHost: %@", host);
    _storedEvent = [CDVPluginResult resultWithHost:host originalURL:originalUrl];
    [self tryToConsumeEvent];
}

- (void)subscribe:(CDVInvokedUrlCommand *)command {
    NSString* eventName = [command.arguments objectAtIndex:0];
    NSLog(@"Cortney sub: %@", eventName);

    if (eventName.length == 0) {
        return;
    }

    _subscribers[eventName] = command.callbackId;
    [self tryToConsumeEvent];
}

/**
 *  Try to send event to the web page.
 *  If there is a subscriber for the event - it will be consumed.
 *  If not - it will stay until someone subscribes to it.
 */
- (void)tryToConsumeEvent {
    if (_subscribers.count == 0 || _storedEvent == nil) {
        return;
    }

    NSString *storedEventName = [_storedEvent eventName];
    for (NSString *eventName in _subscribers) {
        NSLog(@"Cortney tryToConsumeEvent eventname: %@", eventName);
        if ([storedEventName isEqualToString:eventName]) {
            NSString *callbackID = _subscribers[eventName];
            [self.commandDelegate sendPluginResult:_storedEvent callbackId:callbackID];
            _storedEvent = nil;
            break;
        }
    }
}

- (void)unsubscribe:(CDVInvokedUrlCommand *)command {
    NSString* eventName = [command.arguments objectAtIndex:0];
    NSLog(@"Cortney unsub: %@", eventName);
    if (eventName.length == 0) {
        return;
    }

    [_subscribers removeObjectForKey:eventName];
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
    NSLog(@"Cortney handleuseractivity: %@", userActivity.webpageURL);
    [self localInit];

    NSURL *launchURL = userActivity.webpageURL;
    Host *host = [self findHostByURL:launchURL];
    NSLog(@"Cortney host is handleuseractivity: %@", host);
    if (host == nil) {
        return NO;
    }

    [self storeEventWithHost:host originalURL:launchURL];

    return YES;
}

@end
