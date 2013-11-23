//
//  HBQueueItem.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBSongUserTuple.h"

@interface HBQueueItem : HBSongUserTuple

@property (nonatomic, assign) int priority;

@end
