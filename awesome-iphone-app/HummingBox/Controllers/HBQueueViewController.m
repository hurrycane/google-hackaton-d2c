//
//  HBQueueViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBQueueViewController.h"
#import <GooglePlus/GooglePlus.h>

#define kHBTableCellHorizontalPadding                           15

@interface HBQueueViewController () {
    NSArray *_queueItems;
    NSTimer *_pollingTimer;
    UIImageView *_noItemsImageView;
}

@end

@implementation HBQueueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Queue";
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _noItemsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Music Queue"]];
    _noItemsImageView.frame = CGRectZero;
    _noItemsImageView.hidden = YES;
    _noItemsImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _noItemsImageView.contentMode = UIViewContentModeCenter;
    [view addSubview:_noItemsImageView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:_tableView];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"App Logo"]];
    imageView.frame = CGRectMake(0, 0, 129, 21);
    self.navigationItem.titleView = imageView;
    
    // Configure the table header view
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, 320, 30);
    _tableView.tableHeaderView = headerView;
    
    // Configure the table footer view
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.frame = CGRectMake(0, 0, 320, 30);
    _tableView.tableFooterView = footerView;
    
    [self loadQueueItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadQueueItems)
                                                 name:kHBQueueHasChangedNotification
                                               object:nil];

    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                     target:self
                                                   selector:@selector(loadQueueItems)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_pollingTimer) {
        [_pollingTimer invalidate];
    }
}

- (void)loadQueueItems {
    [HBApiClient getQueueWithCallback:^(NSArray *array, NSError *error) {
        _queueItems = array;

        [_tableView reloadData];
        _tableView.hidden = !array.count;
        _noItemsImageView.hidden = array.count;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _queueItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Queue item cell";
    HBQueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HBQueueTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    HBQueueItem *item = [_queueItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.song.title;
    cell.detailTextLabel.text = item.song.artist;
    
    cell.coverImageView.image = nil;
    [cell.coverImageView setImageWithURL:item.song.coverUrl];
    cell.cellCountLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    cell.selectionCircle.hidden = ![item.user.googlePlusID isEqualToString:signIn.googlePlusUser.identifier];
    
    return cell;
}

#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

@end

@interface HBQueueTableViewCell() {
    UIView *_infoPanel;
    UIView *_transparentCircle;
    UIView *_countCircle;
}

@end

@implementation HBQueueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _infoPanel = [[UIView alloc] init];
        _infoPanel.backgroundColor = [UIColor colorWithRed: 48/255.0 green: 51/255.0 blue: 57/255.0 alpha:1.0];
        _infoPanel.layer.cornerRadius = 6;
        [self addSubview:_infoPanel];
        
        _selectionCircle = [[UIView alloc] init];
        _selectionCircle.backgroundColor = [UIColor colorWithRed: 70/255.0 green:170/255.0 blue:213/255.0 alpha:1.0];
        [_infoPanel addSubview:_selectionCircle];
        
        _transparentCircle = [[UIView alloc] init];
        _transparentCircle.backgroundColor = _infoPanel.backgroundColor;
        [_infoPanel addSubview:_transparentCircle];
        
        _countCircle = [[UIView alloc] init];
        _countCircle.backgroundColor = [UIColor colorWithRed: 50/255.0 green: 54/255.0 blue: 60/255.0 alpha:1.0];
        [_infoPanel addSubview:_countCircle];
        
        _cellCountLabel = [[UILabel alloc] init];
        _cellCountLabel.backgroundColor = [UIColor clearColor];
        _cellCountLabel.textColor = [UIColor whiteColor];
        _cellCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16];
        _cellCountLabel.textAlignment = NSTextAlignmentCenter;
        [_countCircle addSubview:_cellCountLabel];
        
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor blackColor];
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
    
    _infoPanel.frame = CGRectMake(kHBTableCellHorizontalPadding,
                                  3,
                                  self.bounds.size.width - 2 * kHBTableCellHorizontalPadding,
                                  self.bounds.size.height - 6);
    
    _selectionCircle.frame = CGRectMake(10,
                                        (_infoPanel.bounds.size.height - 44) / 2,
                                        44,
                                        44);
    _selectionCircle.layer.cornerRadius = 22;
    
    _transparentCircle.frame = CGRectMake(12,
                                          (_infoPanel.bounds.size.height - 44) / 2 + 2,
                                          40,
                                          40);
    _transparentCircle.layer.cornerRadius = 21;
    
    _countCircle.frame = CGRectMake(14,
                                    (_infoPanel.bounds.size.height - 44) / 2 + 4,
                                    36,
                                    36);
    _countCircle.layer.cornerRadius = 18;
    _cellCountLabel.frame = _countCircle.bounds;
    
    
    self.textLabel.frame = CGRectMake(60, 4, _infoPanel.bounds.size.width - 5 - 10 - 58 - 48, 16);
    self.detailTextLabel.frame = CGRectMake(60, 22, _infoPanel.bounds.size.width - 5 - 10 - 58 - 48, 16);
    
    _coverImageView.frame = CGRectMake(_infoPanel.bounds.size.width - 48 - 5, 5, 48, 48);
    
}

@end
