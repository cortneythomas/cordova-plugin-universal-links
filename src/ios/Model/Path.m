#import "Path.h"

@implementation Path

- (instancetype)initWithUrlPath:(NSString *)urlPath andEvent:(NSString *)event {
    self = [super init];
    if (self) {
        _url = [urlPath stringByReplacingOccurrencesOfString:@"*" withString:@".*"].lowercaseString;
        _event = event;
    }

    return self;
}

@end
