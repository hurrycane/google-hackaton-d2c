//
//  HBUser.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBUser.h"

#define kHBGooglePlusAvatarUrl                  @"https://plus.google.com/s2/photos/profile/%@?sz=%d"

@implementation HBUser

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _googlePlusID = [attributes valueForKey:@"userID"];
        _fullName = [attributes valueForKey:@"fullName"];
    }
    return self;
}

- (NSURL *)googlePlusAvatarInSize:(unsigned int)size {
    return [NSURL URLWithString:[NSString stringWithFormat:kHBGooglePlusAvatarUrl,
                                 _googlePlusID,
                                 size]];
}

@end
