#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kTTMHDB;
FOUNDATION_EXPORT NSString *const kMyConstantStringBlank;
FOUNDATION_EXPORT NSString *const kMyConstantStringBlankSt;
FOUNDATION_EXPORT NSString *const kMyConstantTypeMessage[];
FOUNDATION_EXPORT NSUInteger const kMyConstantIntCreatorManager;
FOUNDATION_EXPORT NSString *const kGetUserProductsSQL;
FOUNDATION_EXPORT NSString *const kGetUserProductsCreatedAtSQL;
FOUNDATION_EXPORT NSString *const kGetUserProductsIncludeUserSQL;
///////////////
FOUNDATION_EXPORT NSString *const kNSNotificationTheme;
//
FOUNDATION_EXPORT int const kMyListControllerPopViewFrom9;
FOUNDATION_EXPORT int const kMyListControllerPopViewFrom1;

@interface TTConstant : NSObject

+ (NSArray *)typeMessages;
@end