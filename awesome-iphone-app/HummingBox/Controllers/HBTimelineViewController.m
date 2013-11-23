//
//  HBTimelineViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBTimelineViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define kHBAvatarSize                                           26

@interface HBTimelineViewController () {
    NSArray *_timelineItems;
    UIView *_verticalLine;
}

@end

@implementation HBTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Timeline";
        
        HBUser *user= [[HBUser alloc] init];
        user.fullName = @"Stefan Filip";
        user.googlePlusID = @"100328162309769669535";
        
        HBSong *song = [[HBSong alloc] init];
        song.title = @"Yellow";
        song.artist = @"Coldplay";
        song.coverUrl = [NSURL URLWithString:@"http://rekwired.com/wp-content/uploads/2009/11/coldplay-xy.jpg"];
        
        HBTimelineItem *item = [[HBTimelineItem alloc] init];
        item.user = user;
        item.song = song;
        
        _timelineItems = @[item, item, item, item, item];
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _verticalLine = [[UIView alloc] init];
    _verticalLine.backgroundColor = [UIColor grayColor];
    _verticalLine.frame = CGRectMake((44 - 2) / 2, 0, 2, 0);
    _verticalLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [view addSubview:_verticalLine];
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timelineItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Timeline item cell";
    HBTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HBTimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    HBTimelineItem *item = [_timelineItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.song.title;
    cell.detailTextLabel.text = item.song.artist;
    
    cell.coverImageView.image = nil;
    cell.avatarImageView.image = nil;
    [cell.avatarImageView setImageWithURL:[item.user googlePlusAvatarInSize:200]];
    [cell.coverImageView setImageWithURL:item.song.coverUrl];
    
    return cell;
}

@end

@interface HBTimelineTableViewCell() {
}

@end

@implementation HBTimelineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _avatarImageView.layer.borderWidth = 2;
        _avatarImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_avatarImageView];
        
        _coverImageView = [[UIImageView alloc] init];
        [self addSubview:_coverImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _avatarImageView.frame = CGRectMake((44 - kHBAvatarSize) / 2,
                                        (self.bounds.size.height - kHBAvatarSize) / 2,
                                        kHBAvatarSize,
                                        kHBAvatarSize);
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2;
    
    self.textLabel.frame = CGRectMake(50, 0, 200, 22);
    self.detailTextLabel.frame = CGRectMake(50, 22, 200, 22);
    
    _coverImageView.frame = CGRectMake(self.bounds.size.width - 44, 0, 44, 44);
}

@end
