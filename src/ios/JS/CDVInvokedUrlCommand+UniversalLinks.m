#import "CDVInvokedUrlCommand+UniversalLinks.h"

@implementation CDVInvokedUrlCommand (UniversalLinks)

- (NSString *)eventName {
    if (self.arguments.count == 0) {
        return nil;
    }

    return self.arguments[0];
}

@end
