//
//  HBAddSongViewController.m
//  HummingBox
//
//  Created by Stefan Filip on 23/11/13.
//  Copyright (c) 2013 Hack Attack. All rights reserved.
//

#import "HBAddSongViewController.h"

@interface HBAddSongViewController () {
    NSMutableArray *_songs;
    NSArray *_filteredSongs;
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
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.frame = CGRectMake(0, statusBarHeight, 0, 44);
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:searchBar];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, statusBarHeight + 44, 0, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [view addSubview:_tableView];
    
    self.view = view;    
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

#pragma mark - Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredSongs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Song item cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    HBSong *song = [_filteredSongs objectAtIndex:indexPath.row];
    cell.textLabel.text = song.title;
    cell.detailTextLabel.text = song.artist;
    
    return cell;
}

@end
