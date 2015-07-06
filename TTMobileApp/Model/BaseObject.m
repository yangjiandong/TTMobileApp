
#import "BaseObject.h"


@implementation BaseObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

@end