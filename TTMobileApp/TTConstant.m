#import "TTConstant.h"

NSString *const kTTMHDB = @"ttmh.db";
NSString *const kMyConstantStringBlank = @"";
NSString *const kMyConstantStringBlankSt = @"-";
NSString *const kMyConstantTypeMessage[] = {@"评论了你", @"赞了你的作品", @"对你发送了私信", @"回复了你", @"关注了你", @"大作中提到了你"};
//自定义角色
NSUInteger const kMyConstantIntCreatorManager = 9;

//
NSString *const kGetUserProductsSQL =
        @"select * from Product "
                "where optType in(0,1) and (user in (select concernUser from UserFriend where selfUser=pointer('_User',?) limit 0, 999) or user =pointer('_User',?)) "
                "limit 1 order by createdAt desc";

//
NSString *const kGetUserProductsCreatedAtSQL =
        @"select createdAt from Product "
                "where optType in(0,1) and (user in (select concernUser from UserFriend where selfUser=pointer('_User',?) limit 0, 999) or user =pointer('_User',?)) limit 1 order by createdAt desc";

NSString *const kGetUserProductsIncludeUserSQL =
        @"select include user,* from Product "
                "where optType in(0,1) and (user in (select concernUser from UserFriend where selfUser=pointer('_User',?) limit 0, 999) or user =pointer('_User',?)) "
                "limit ?,? order by createdAt desc";

/*
评论了你":  1
@"赞了你的作品",  2
@对你发送了私信  3
@"回复了你",  4
@"关注了你",  5
@"大作中提到了你"};6
没有  对你的作品发表了评论
*/

//////////

NSString *const kNSNotificationTheme = @"dawnAndNight";

//
//NSString *const kNSNotificationTheme = @"dawnAndNight";

int const kMyListControllerPopViewFrom9 = 9;
int const kMyListControllerPopViewFrom1 = 1;

@implementation TTConstant

+ (NSArray *)typeMessages {
    static NSArray *names;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = [NSArray arrayWithObjects:kMyConstantTypeMessage count:6];
    });

    return names;
}

@end