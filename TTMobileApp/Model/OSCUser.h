#import "BaseObject.h"

@interface OSCUser : BaseObject

@property (nonatomic, readwrite, assign) int64_t userID;
@property (nonatomic, readonly, copy) NSString *location;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readonly, assign) int followersCount;
@property (nonatomic, readonly, assign) int fansCount;
@property (nonatomic, readonly, assign) int score;
@property (nonatomic, readonly, assign) int favoriteCount;
@property (nonatomic, assign)           int relationship;
@property (nonatomic, readwrite, strong) NSURL *portraitURL;
@property (nonatomic, readonly, copy) NSString *gender;
@property (nonatomic, readonly, copy) NSString *developPlatform;
@property (nonatomic, readonly, copy) NSString *expertise;
@property (nonatomic, readonly, copy) NSString *joinTime;
@property (nonatomic, readonly, copy) NSString *latestOnlineTime;

@end
