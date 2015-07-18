//
// Created by yangjiandong on 15/7/17.
// Copyright (c) 2015 tt.org. All rights reserved.
//

#import "MyInfo.h"
#import "Tool.h"


@implementation MyInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _name = [Tool checkNSNullClass:attributes[@"name"]];
        _portraitURL = [Tool checkNSNullClass:attributes[@"portraitURL"]];


    }

    return self;
}

- (void)setDetailInformationJointime:(NSString *)jointime
                         andHometown:(NSString *)hometown
                  andDevelopPlatform:(NSString *)developPlatform
                        andExpertise:(NSString *)expertise
{
    _joinTime = jointime;
    _hometown = hometown;
    _developPlatform = developPlatform;
    _expertise = expertise;
}
@end