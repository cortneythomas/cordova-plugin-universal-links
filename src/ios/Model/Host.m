#import "Host.h"

// default event name
static NSString *const DEFAULT_EVENT = @"didLaunchAppFromLink";

// default host scheme
static NSString *const DEFAULT_SCHEME = @"http";

@interface Host() {
    NSMutableArray<Path *> *_paths;
}

@end

@implementation Host

- (instancetype)initWithHostName:(NSString *)name scheme:(NSString *)scheme event:(NSString *)event {
    self = [super init];
    if (self) {
        _event = event ? event : DEFAULT_EVENT;
        _scheme = scheme ? scheme : DEFAULT_SCHEME;
        _name = name.lowercaseString;
        _paths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addPath:(Path *)path {
    if (path) {
        [_paths addObject:path];
    }
}

- (void)addAllPaths:(NSArray<Path *> *)paths {
    if (paths) {
        [_paths addObjectsFromArray:paths];
    }
}

- (NSArray<Path *> *)paths {
    return _paths;
}

@end
