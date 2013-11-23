//
//  HBAddSongViewController.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBAddSongViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) CGRect initialFrame;

- (void)fixTableViewFrame;

@end

@interface HBAddSongTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;

@end
