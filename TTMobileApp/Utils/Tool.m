

#import "Tool.h"


@implementation Tool


+ (NSString *)checkNSNullClass:(id) param {
    if (![param isKindOfClass:[NSNull class]]) {
        return param;
    } else {
        return @"";
    }
}

@end