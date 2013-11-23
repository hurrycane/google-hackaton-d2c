//
//  HBAddSongViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBAddSongViewController.h"
#import <GooglePlus/GooglePlus.h>

#define kHBTableCellHorizontalPadding                           15
#define kHBTableCellHeight                                      60

@interface HBAddSongViewController () {
    NSMutableArray *_songs;
    NSArray *_filteredSongs;
    UIButton *_closeButton;
}

@end

@implementation HBAddSongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Add Song";
        _songs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithRed: 45/255.0 green: 48/255.0 blue: 53/255.0 alpha:1.0];
    backgroundView.frame = CGRectMake(0, 30, 0, 0);
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:backgroundView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(0, 0, 60, 60);
    _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_closeButton setImage:[UIImage imageNamed:@"Close Button"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"Close Button Selected"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_closeButton];
    
    UIView *searchBackView = [[UIView alloc] init];
    searchBackView.backgroundColor = [UIColor whiteColor];
    searchBackView.frame = CGRectMake(8, 79, 304, 26);
    searchBackView.layer.cornerRadius = 3;
    [view addSubview:searchBackView];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.frame = CGRectMake(0, 70, 0, 44);
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 70 + 44, 0, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor colorWithRed: 58/255.0 green: 63/255.0 blue: 71/255.0 alpha:1.0];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kHBTableCellHorizontalPadding, 0, kHBTableCellHorizontalPadding)];
    [view addSubview:_tableView];
    
    self.view = view;    
}

- (void)closeWindow {
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.view.frame = _initialFrame;
                         _closeButton.transform = CGAffineTransformMakeRotation(M_PI/4);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              self.view.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                              [self.view removeFromSuperview];
                                              [self removeFromParentViewController];
                                          }];
                     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [HBApiClient browseSongsWithCallback:^(NSArray *array, NSError *error) {
        _songs = [NSMutableArray arrayWithArray:array];
        
        [self searchForSongs:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchForSongs:(NSString *)searchTerm {
    if (searchTerm && ![searchTerm isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(artist CONTAINS[cd] %@) OR (title CONTAINS[cd] %@)", searchTerm, searchTerm];
        _filteredSongs = [_songs filteredArrayUsingPredicate:predicate];
    }
    else {
        _filteredSongs = _songs;
    }
    
    [_tableView reloadData];
}

#pragma mark - Search Bar delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForSongs:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

#pragma mark - Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredSongs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Song item cell";
    HBAddSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HBAddSongTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UIView *selectionBackgroundView = [[UIView alloc] init];
        selectionBackgroundView.backgroundColor = [UIColor colorWithRed: 58/255.0 green: 63/255.0 blue: 71/255.0 alpha:1.0];
        selectionBackgroundView.frame = CGRectMake(0, 0, tableView.bounds.size.width, kHBTableCellHeight);
        cell.selectedBackgroundView = selectionBackgroundView;
    }
    
    HBSong *song = [_filteredSongs objectAtIndex:indexPath.row];
    cell.textLabel.text = song.title;
    cell.detailTextLabel.text = song.artist;
    
    cell.coverImageView.image = nil;
    [cell.coverImageView setImageWithURL:song.coverUrl];
    
    return cell;
}

#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHBTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSong *song = [_filteredSongs objectAtIndex:indexPath.row];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    [HBApiClient postSongToQueue:song.songId
                    googleUserId:signIn.googlePlusUser.identifier
                     andCallback:^(BOOL result, NSError *error) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:kHBQueueHasChangedNotification object:nil];
                         [self closeWindow];
                     }];
}

@end

@implementation HBAddSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.detailTextLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
        self.detailTextLabel.textColor = [UIColor colorWithRed:167/255.0 green:168/255.0 blue:169/255.0 alpha:1.0];
        
        self.imageView.backgroundColor = [UIColor blackColor];
        
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_coverImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _coverImageView.frame = CGRectMake(self.bounds.size.width - 15 - 40,
                                       (self.bounds.size.height - 40) / 2,
                                       40,
                                       40);
}

@end
