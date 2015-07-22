//
//  OSCUser.m
//  iosapp
//
//  Created by chenhaoxiang on 11/5/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OSCUser.h"

static NSString * const kID = @"uid";
static NSString * const kUserID = @"userid";
static NSString * const kLocation = @"location";
static NSString * const kFrom = @"from";
static NSString * const kName = @"name";
static NSString * const kFollowers = @"followers";
static NSString * const kFans = @"fans";
static NSString * const kScore = @"score";
static NSString * const kPortrait = @"portrait";
static NSString * const kFavoriteCount = @"favoritecount";
static NSString * const kExpertise = @"expertise";

@interface OSCUser ()

@end


@implementation OSCUser

- (instancetype)initWithAttributes:(NSDictionary *)attributes {

    self = [super init];
    if (!self) {return nil;}

    _userID = (int64_t) [attributes[@"uid"] pointerValue];
    // TODO

    return self;
}


- (BOOL)isEqual:(id)object
{
    if ([self class] == [object class]) {
        return _userID == ((OSCUser *)object).userID;
    }
    
    return NO;
}


@end
