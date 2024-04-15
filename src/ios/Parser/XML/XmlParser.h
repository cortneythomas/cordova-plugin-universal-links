#import <Foundation/Foundation.h>
#import "Host.h"

/**
 *  Parser for config.xml. Reads only plugin-specific preferences.
 */
@interface XmlParser : NSObject

/**
 *  Parse config.xml
 *
 *  @return list of hosts, defined in the config file
 */
+ (NSArray<Host *> *)parse;

@end
