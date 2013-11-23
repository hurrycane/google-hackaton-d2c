//
//  HBSongUserTuple.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBSongUserTuple.h"

@implementation HBSongUserTuple

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        if ([attributes valueForKey:@"user"] != [NSNull null]) {
            _user = [[HBUser alloc] initWithAttributes:[attributes valueForKey:@"user"]];
        }
        _song = [[HBSong alloc] initWithAttributes:[attributes valueForKey:@"song"]];
    }
    return self;
}

@end
