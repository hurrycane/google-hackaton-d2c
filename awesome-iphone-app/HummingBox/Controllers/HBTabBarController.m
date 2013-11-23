//
//  HBTabBarViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBTabBarController.h"
#import "HBTimelineViewController.h"
#import "HBAddSongViewController.h"
#import "HBQueueViewController.h"

@implementation HBTabBarController

- (id)init {
    self = [super init];
    if (self) {
        HBTimelineViewController *timelineController = [[HBTimelineViewController alloc] init];
        HBAddSongViewController *addSongController = [[HBAddSongViewController alloc] init];
        HBQueueViewController *queueController = [[HBQueueViewController alloc] init];
        
        UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:timelineController];
        navigationController1.navigationBar.translucent = NO;
        UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:queueController];
        navigationController2.navigationBar.translucent = NO;        
        
        [self setViewControllers:@[navigationController1, addSongController, navigationController2]];
    }
    return self;
}

@end
