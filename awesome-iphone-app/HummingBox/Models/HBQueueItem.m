//
//  HBQueueItem.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBQueueItem.h"

@implementation HBQueueItem

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (self) {
        _priority = [[attributes valueForKey:@"priority"] integerValue];
    }
    return self;
}

@end
