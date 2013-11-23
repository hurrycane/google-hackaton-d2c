//
//  HBSong.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBSong.h"

@implementation HBSong

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _songId = [attributes valueForKey:@"songId"];
        _title = [attributes valueForKey:@"title"];
        _artist = [attributes valueForKey:@"artist"];
        _album = [attributes valueForKey:@"album"];
        _genre = [attributes valueForKey:@"genre"];
        _coverUrl = [NSURL URLWithString:[attributes valueForKey:@"coverUrl"]];
        if ([attributes valueForKey:@"duration"]) {
            _duration = [[attributes valueForKey:@"duration"] floatValue];
        }
    }
    
    return self;
}

@end
