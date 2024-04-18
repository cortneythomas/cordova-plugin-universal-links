#import "XmlParser.h"
#import "NSBundle+UniversalLinks.h"
#import "Path.h"
#import "XmlTags.h"

@interface XmlParser() <NSXMLParserDelegate> {
    NSMutableArray<Host *> *_hostsList;
    BOOL _isInsideMainTag;
    BOOL _didParseMainBlock;
    BOOL _isInsideHostBlock;
    Host *_processedHost;
}

@end

@implementation XmlParser

#pragma mark Public API

+ (NSArray<Host *> *)parse {
    XmlParser *parser = [[XmlParser alloc] init];

    return [parser parseConfig];
}

- (NSArray<Host *> *)parseConfig {
    NSURL *cordovaConfigURL = [NSURL fileURLWithPath:[NSBundle pathToCordovaConfigXml]];
    NSXMLParser *configParser = [[NSXMLParser alloc] initWithContentsOfURL:cordovaConfigURL];
    if (configParser == nil) {
        NSLog(@"Failed to initialize XML parser.");
        return nil;
    }

    _hostsList = [[NSMutableArray alloc] init];
    [configParser setDelegate:self];
    [configParser parse];

    NSLog(@"Cortney _hostsList in parseConfig: %@", _hostsList);
    for (Host *cortneyHost in _hostsList) {
        NSLog(@"Cortney each host in supported host in parser: %@", cortneyHost.name);
    }
    return _hostsList;
}

#pragma mark NSXMLParserDelegate implementation

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if (_didParseMainBlock) {
        return;
    }

    if ([elementName isEqualToString:kMainXmlTag]) {
        _isInsideMainTag = YES;
        return;
    }
    if (!_isInsideMainTag) {
        return;
    }

    if ([elementName isEqualToString:kHostXmlTag]) {
        [self processHostTag:attributeDict];
    } else if ([elementName isEqualToString:kPathXmlTag]) {
        [self processPathTag:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (_didParseMainBlock || !_isInsideMainTag) {
        return;
    }

    if ([elementName isEqualToString:kHostXmlTag]) {
        _isInsideHostBlock = NO;
        [_hostsList addObject:_processedHost];
    }
}

#pragma mark XML Processing

/**
 *  Parse host tag.
 *
 *  @param attributes host tag attributes
 */
- (void)processHostTag:(NSDictionary<NSString *, NSString *> *)attributes {
    _processedHost = [[Host alloc] initWithHostName:attributes[kHostNameXmlAttribute]
                                                scheme:attributes[kHostSchemeXmlAttribute]
                                                 event:attributes[kHostEventXmlAttribute]];
    _isInsideHostBlock = YES;
}

/**
 *  Parse path tag.
 *
 *  @param attributes path tag attributes
 */
- (void)processPathTag:(NSDictionary<NSString *, NSString *> *)attributes {
    NSString *urlPath = attributes[kPathUrlXmlAttribute];
    NSString *event = attributes[kPathEventXmlAttribute];

    // ignore '*' paths; we don't need them here
    if ([urlPath isEqualToString:@"*"] || [urlPath isEqualToString:@".*"]) {
        // but if path has event name - set it to host
        if (event) {
            _processedHost.event = event;
        }

        return;
    }

    // if event name is empty - use one from the host
    if (event == nil) {
        event = _processedHost.event;
    }

    // create path entry
    Path *path = [[Path alloc] initWithUrlPath:urlPath andEvent:event];
    [_processedHost addPath:path];
}

@end
