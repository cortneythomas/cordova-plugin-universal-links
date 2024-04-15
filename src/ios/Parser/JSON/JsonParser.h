#import <Foundation/Foundation.h>
#import "Host.h"

/**
 *  JSON parser for plugin's preferences.
 */
@interface JsonParser : NSObject

/**
 *  Parse JSON config.
 *
 *  @return list of hosts, defined in the config file
 */
+ (NSArray<Host *> *)parseConfig:(NSString *)pathToJsonConfig;

@end
