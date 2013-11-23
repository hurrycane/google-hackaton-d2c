//
//  HBSongUserTuple.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "AFHTTPClient.h"
#import "HBUser.h"
#import "HBSong.h"

@interface HBSongUserTuple : NSObject

@property (nonatomic, strong) HBUser *user;
@property (nonatomic, strong) HBSong *song;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
