#import "JsonParser.h"

@implementation JsonParser

+ (NSArray<Host *> *)parseConfig:(NSString *)pathToJsonConfig {
    NSData *ulData = [NSData dataWithContentsOfFile:pathToJsonConfig];
    if (!ulData) {
        return nil;
    }

    NSError *error = nil;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:ulData options:kNilOptions error:&error];
    if (error) {
        return nil;
    }

    NSMutableArray<Host *> *preferences = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonEntry in jsonObject) {
        Host *host = [[Host alloc] initWithHostName:jsonEntry[@"host"]
                                                   scheme:jsonEntry[@"scheme"]
                                                    event:jsonEntry[@"event"]];
        NSArray<Path *> *paths = [self parsePathsFromJson:jsonEntry[@"path"] forHost:host];
        [host addAllPaths:paths];

        [preferences addObject:host];
    }

    return preferences;
}

+ (NSArray<Path *> *)parsePathsFromJson:(NSArray *)jsonArray forHost:(Host *)host {
    if (!jsonArray || !jsonArray.count) {
        return nil;
    }

    NSMutableArray<Path *> *paths = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    for (NSDictionary *entry in jsonArray) {
        NSString *urlPath = entry[@"url"];
        NSString *pathEvent = entry[@"event"] ? entry[@"event"] : host.event;

        // ignore '*' paths; we don't need them here
        if ([urlPath isEqualToString:@"*"] || [urlPath isEqualToString:@".*"]) {
            continue;
        }

        // create path entry
        Path *path = [[Path alloc] initWithUrlPath:urlPath andEvent:pathEvent];
        [paths addObject:path];
    }

    return paths;
}

@end
