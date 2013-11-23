//
//  HBTimelineItem.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBSongUserTuple.h"

@interface HBTimelineItem : HBSongUserTuple

@property (nonatomic, strong) NSDate *startedDate;
@property (nonatomic, assign) BOOL isPlaying;

@end
