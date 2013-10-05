//
//  CVSearchViewController.m
//  Copyright (c) 2013 Kasper Timm Hansen. All rights reserved.
//

#import "CVSearchTableViewController.h"
#import "CVTableViewArrayDataSource.h"
#import "CVCompoundPredicateFilter.h"

NSString * const CVSearchTableViewControllerLoadDataNotification = @"CVSearchTableViewControllerLoadDataNotification";

@interface CVSearchTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) CVTableViewArrayDataSource *searchResultsDataSource;

@property (nonatomic, strong) CVCompoundPredicateFilter *compoundPredicateFilter;

@property (nonatomic, strong) NSString *previousSearchString;

@end

@implementation CVSearchTableViewController

#pragma mark - UIView

- (void)viewDidLoad
{
    self.searchResultsDataSource = [[CVTableViewArrayDataSource alloc] initWithTableView:self.tableView];
    self.searchResultsDataSource.hideHeadersForEmptySections = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CVSearchTableViewControllerLoadDataNotification object:self];
    
    __weak __typeof(self) weakSelf = self;
    self.searchResultsDataSource.didSelectRowHandler = ^(NSIndexPath *indexPath, id object) {
        [weakSelf dismissWithObject:object atIndexPath:indexPath];
    };
    self.searchResultsDataSource.dequeueFromTableViewHandler = ^(UITableView *tableView) {
        return weakSelf.tableView;
    };

    self.searchDisplayController.searchResultsDataSource = self.searchResultsDataSource;
    self.searchDisplayController.searchResultsDelegate = self.searchResultsDataSource;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

- (void)setSearchData:(NSArray *)searchData
{
    if (_searchData == searchData)
        return;
    _searchData = searchData;
    self.compoundPredicateFilter = [CVCompoundPredicateFilter compoundFilterWithSegmentedObjects:searchData templatePredicate:self.searchPredicate];
}

#pragma mark - UISearcDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    void (^completionHandler)(NSArray *filteredResults) = ^(NSArray *filteredResults) {
        self.searchResultsDataSource.objects = filteredResults;
        [self.searchDisplayController.searchResultsTableView reloadData];
    };
    
    NSString *firstCharacter = [searchString length] == 0 ? @"" : [searchString substringToIndex:1];
    if (self.previousSearchString && ![self.previousSearchString hasPrefix:firstCharacter])
        [self.compoundPredicateFilter popFiltersWithCompletionHandler:completionHandler];
    else if ([searchString length] < [self.previousSearchString length]) {
        NSUInteger difference = [self.previousSearchString length] - [searchString length];
        [self.compoundPredicateFilter popToFilterAtIndex:[self.compoundPredicateFilter.filters count] - difference withCompletionHandler:completionHandler];
    } else
        [self.compoundPredicateFilter pushFilterWithSubstitutionValues:@{ @"searchTerm": searchString } completionHandler:completionHandler];
    
    self.previousSearchString = [searchString isEqualToString:@""] ? nil : searchString;
    
    return NO; // pushFilter returns immediately, call -reloadData in completionHandler.
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.compoundPredicateFilter popFiltersWithCompletionHandler:^(NSArray *filteredResults) {
        self.searchResultsDataSource.objects = filteredResults;
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissWithObject:nil atIndexPath:nil];
}

#pragma mark - Private

- (void)dismissWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (self.willDismissWithPickHandler)
        self.willDismissWithPickHandler(object, indexPath);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
