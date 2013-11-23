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

#define kHBOffsetYAdd                                   80

@interface HBTabBarController() {
    UIButton *_timelineButton;
    UIButton *_queueButton;
    UIButton *_addButton;
}

@end

@implementation HBTabBarController

- (id)init {
    self = [super init];
    if (self) {
        HBTimelineViewController *timelineController = [[HBTimelineViewController alloc] init];
        HBQueueViewController *queueController = [[HBQueueViewController alloc] init];
        
        UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:timelineController];
        navigationController1.navigationBar.translucent = NO;
        UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:queueController];
        navigationController2.navigationBar.translucent = NO;        
        
        [self setViewControllers:@[navigationController1, navigationController2]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timelineButton = [self tabBarButton];
    [_timelineButton setTitle:@"TIMELINE" forState:UIControlStateNormal];
    [_timelineButton addTarget:self action:@selector(timeline) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timelineButton];
    [_timelineButton setSelected:YES];
    
    _queueButton = [self tabBarButton];
    [_queueButton setTitle:@"QUEUE" forState:UIControlStateNormal];
    [_queueButton addTarget:self action:@selector(queue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_queueButton];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setImage:[UIImage imageNamed:@"Add Button"] forState:UIControlStateNormal];
    [_addButton setImage:[UIImage imageNamed:@"Add Button Selected"] forState:UIControlStateHighlighted];
    [_addButton addTarget:self action:@selector(addSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
}

- (void)timeline {
    _queueButton.selected = NO;
    _timelineButton.selected = YES;
    self.selectedIndex = 0;
}

- (void)queue {
    _queueButton.selected = YES;
    _timelineButton.selected = NO;
    self.selectedIndex = 1;
}

- (void)addSong {
    HBAddSongViewController *addSongController = [[HBAddSongViewController alloc] init];
    addSongController.view.frame = CGRectMake(0,
                                              self.tabBar.frame.origin.y - 30,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height - kHBOffsetYAdd);
    addSongController.initialFrame = addSongController.view.frame;
    addSongController.view.alpha = 0.0;
    [self addChildViewController:addSongController];
    [self.view addSubview:addSongController.view];
    [addSongController fixTableViewFrame];
    [UIView animateWithDuration:0.25
                     animations:^{
                         addSongController.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = addSongController.view.frame;
                         frame.origin.y = kHBOffsetYAdd;
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              addSongController.view.frame = frame;
                                          }];
                     }
     ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _timelineButton.frame = CGRectMake(0,
                                       self.tabBar.frame.origin.y,
                                       self.tabBar.frame.size.width / 2,
                                       self.tabBar.frame.size.height);
    
    _queueButton.frame = CGRectMake(self.tabBar.frame.size.width / 2,
                                    self.tabBar.frame.origin.y,
                                    self.tabBar.frame.size.width / 2,
                                    self.tabBar.frame.size.height);
    
    _addButton.frame = CGRectMake((self.view.bounds.size.width - 60) / 2,
                                  self.tabBar.frame.origin.y - 30,
                                  60,
                                  60);
}

- (UIButton *)tabBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"Tab Bar Button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Tab Bar Button Selected"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"Tab Bar Button Selected"] forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
    [button setTitleColor:[UIColor colorWithRed: 70/255.0 green:170/255.0 blue:213/255.0 alpha:1.0]
                 forState:UIControlStateNormal];
    
    return button;
}

@end
