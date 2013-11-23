//
//  HBQueueViewController.h
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBQueueViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@interface HBQueueTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *cellCountLabel;
@property (nonatomic, strong) UIView *selectionCircle;

@end
