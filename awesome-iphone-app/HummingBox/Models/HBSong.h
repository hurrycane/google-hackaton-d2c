//
//  HBSong.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSong : NSObject

@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSURL *coverUrl;
@property (nonatomic, assign) float duration;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
