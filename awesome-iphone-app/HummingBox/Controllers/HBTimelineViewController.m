//
//  HBTimelineViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBTimelineViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define kHBAvatarSize                                           45
#define kHBTableCellHeight                                      65
#define kHBTableCellHorizontalPadding                           15
#define kHBVerticalLineWidth                                    3

@interface HBTimelineViewController () {
    NSArray *_timelineItems;
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
        
        _timelineItems = @[item, item, item, item, item, item, item, item, item];
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"App Logo"]];
    imageView.frame = CGRectMake(0, 0, 129, 21);
    self.navigationItem.titleView = imageView;
    
    // Create the table header
    UIView *tableHeader = [[UIView alloc] init];
    tableHeader.backgroundColor = [UIColor clearColor];
    tableHeader.frame = CGRectMake(0, 0, 320, 30);
    
    UIView *startMarker = [[UIView alloc] init];
    startMarker.layer.cornerRadius = 5;
    startMarker.frame = CGRectMake(kHBTableCellHorizontalPadding + (kHBAvatarSize - 10) / 2,
                                   10,
                                   11,
                                   11);
    startMarker.backgroundColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0];
    [tableHeader addSubview:startMarker];
    
    UIView *lineHeader = [[UIView alloc] init];
    lineHeader.backgroundColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0];
    lineHeader.frame = CGRectMake(kHBTableCellHorizontalPadding + (kHBAvatarSize - kHBVerticalLineWidth) / 2,
                                  15,
                                  kHBVerticalLineWidth,
                                  15);
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"NOW PLAYING";
    headerLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:10];
    headerLabel.textColor = [UIColor colorWithRed: 70/255.0 green:170/255.0 blue:213/255.0 alpha:1.0];
    headerLabel.frame = CGRectMake(kHBTableCellHorizontalPadding + kHBAvatarSize / 2 + 20,
                                   0,
                                   200,
                                   30);
    [tableHeader addSubview:headerLabel];
    [tableHeader addSubview:lineHeader];
    
    _tableView.tableHeaderView = tableHeader;
    
    // Create the table footer
    UIView *tableFooter = [[UIView alloc] init];
    tableFooter.backgroundColor = [UIColor clearColor];
    tableFooter.frame = CGRectMake(0, 0, 320, 30);
    
    UIView *endMarker = [[UIView alloc] init];
    endMarker.layer.cornerRadius = 5;
    endMarker.frame = CGRectMake(kHBTableCellHorizontalPadding + (kHBAvatarSize - 10) / 2,
                                   10,
                                   11,
                                   11);
    endMarker.backgroundColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0];
    [tableFooter addSubview:endMarker];
    
    UIView *lineFooter = [[UIView alloc] init];
    lineFooter.backgroundColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0];
    lineFooter.frame = CGRectMake(kHBTableCellHorizontalPadding + (kHBAvatarSize - kHBVerticalLineWidth) / 2,
                                  0,
                                  kHBVerticalLineWidth,
                                  15);
    [tableFooter addSubview:lineFooter];
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"END";
    footerLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:10];
    footerLabel.textColor = [UIColor colorWithRed: 70/255.0 green:170/255.0 blue:213/255.0 alpha:1.0];
    footerLabel.frame = CGRectMake(kHBTableCellHorizontalPadding + kHBAvatarSize / 2 + 20,
                                   0,
                                   200,
                                   30);
    [tableFooter addSubview:footerLabel];
    
    _tableView.tableFooterView = tableFooter;
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

#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

@end

@interface HBTimelineTableViewCell() {
    UIView *_line;
    UIView *_infoPanel;
}

@end

@implementation HBTimelineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0];
        [self addSubview:_line];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0].CGColor;
        _avatarImageView.layer.borderWidth = 2;
        _avatarImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_avatarImageView];
        
        _infoPanel = [[UIView alloc] init];
        _infoPanel.backgroundColor = [UIColor colorWithRed: 48/255.0 green: 51/255.0 blue: 57/255.0 alpha:1.0];
        _infoPanel.layer.cornerRadius = 6;
        [self addSubview:_infoPanel];
        
        _coverImageView = [[UIImageView alloc] init];
        [_infoPanel addSubview:_coverImageView];
        
        self.textLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        self.textLabel.textColor = [UIColor whiteColor];
        [_infoPanel addSubview:self.textLabel];
        
        self.detailTextLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
        self.detailTextLabel.textColor = [UIColor colorWithRed:167/255.0 green:168/255.0 blue:169/255.0 alpha:1.0];
        [_infoPanel addSubview:self.detailTextLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _line.frame = CGRectMake(kHBTableCellHorizontalPadding + (kHBAvatarSize - kHBVerticalLineWidth) / 2,
                             0,
                             kHBVerticalLineWidth,
                             self.bounds.size.height);
    _avatarImageView.frame = CGRectMake(kHBTableCellHorizontalPadding,
                                        (self.bounds.size.height - kHBAvatarSize) / 2,
                                        kHBAvatarSize,
                                        kHBAvatarSize);
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2;
    
    _infoPanel.frame = CGRectMake(kHBTableCellHorizontalPadding + kHBAvatarSize + 10,
                                  4,
                                  self.bounds.size.width - 2 * kHBTableCellHorizontalPadding - 10 - kHBAvatarSize,
                                  self.bounds.size.height - 8);
    
    self.textLabel.frame = CGRectMake(10, 4, _infoPanel.bounds.size.width - 4 - 10 - 58, 16);
    self.detailTextLabel.frame = CGRectMake(10, 22, _infoPanel.bounds.size.width - 4 - 10 - 58, 14);
    
    _coverImageView.frame = CGRectMake(_infoPanel.bounds.size.width - 48 - 4, 4, 48, 48);
}

@end
