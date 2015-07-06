
#import <Foundation/Foundation.h>
#import "BaseObject.h"


@interface ExampleData : BaseObject

@property (nonatomic) NSUInteger *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *author;

@end