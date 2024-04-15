#import <Foundation/Foundation.h>

/**
 *  XML tags that is used in config.xml to specify plugin preferences.
 */
@interface XmlTags : NSObject

/**
 *  Main tag in which we define plugin related stuff
 */
extern NSString *const kMainXmlTag;

/**
 *  Host main tag
 */
extern NSString *const kHostXmlTag;

/**
 *  Scheme attribute for the host entry
 */
extern NSString *const kHostSchemeXmlAttribute;

/**
 *  Name attribute for the host entry
 */
extern NSString *const kHostNameXmlAttribute;

/**
 *  Event attribute for the host entry
 */
extern NSString *const kHostEventXmlAttribute;

/**
 *  Path main tag
 */
extern NSString *const kPathXmlTag;

/**
 *  Url attribute for the path entry
 */
extern NSString *const kPathUrlXmlAttribute;

/**
 *  Event attribute for the path entry
 */
extern NSString *const kPathEventXmlAttribute;

@end
