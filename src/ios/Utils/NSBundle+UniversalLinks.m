#import "NSBundle+UniversalLinks.h"

@implementation NSBundle (UniversalLinks)

+ (NSString *)pathToCordovaConfigXml {
    return [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
}

@end
