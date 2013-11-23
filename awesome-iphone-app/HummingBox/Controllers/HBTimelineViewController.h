//
//  HBTimelineViewController.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBTimelineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@interface HBTimelineTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UIImageView *nowPlayingImageView;

@end