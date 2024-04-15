#import <Foundation/Foundation.h>

/**
 *  Helper category to work with NSBundle.
 */
@interface NSBundle (UniversalLinks)

/**
 *  Path to the config.xml file in the project.
 *
 *  @return path to the config file
 */
+ (NSString *)pathToCordovaConfigXml;


@end
