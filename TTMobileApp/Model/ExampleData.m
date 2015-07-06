
#import "ExampleData.h"
#import "Tool.h"


@implementation ExampleData

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.id  = [attributes[@"patientId"] pointerValue];
        self.name = [Tool checkNSNullClass:attributes[@"name"]];
        self.body = [Tool checkNSNullClass:attributes[@"body"]];
        self.memo = [Tool checkNSNullClass:attributes[@"memo"]];
        self.author = [Tool checkNSNullClass:attributes[@"author"]];

    }

    return self;
}

@end