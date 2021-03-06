//
//  CVSearchViewController.m
//  Copyright (c) 2013 Kasper Timm Hansen. All rights reserved.
//

#import "CVSearchTableViewController.h"
#import "CVCompoundPredicateFilter.h"

@interface CVSearchTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) CVCompoundPredicateFilter *compoundPredicateFilter;

@property (nonatomic, strong) NSString *previousSearchString;

@end

@implementation CVSearchTableViewController

#pragma mark - CVArrayTableViewController

- (BOOL)hideHeadersForEmptySections
{
    return YES;
}

- (CVTableViewRowAtIndexPathHandler)didSelectRowHandler
{
    return ^(NSIndexPath *indexPath, id object) {
        [self dismissWithObject:object atIndexPath:indexPath];
    };
}

- (CVDequeueFromTableViewHandler)dequeueFromTableViewHandler
{
    return ^(UITableView *tableView) {
        return self.tableView;
    };
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;

    self.objects = self.searchData;
    if (!self.compoundPredicateFilter)
        self.compoundPredicateFilter = [CVCompoundPredicateFilter compoundFilterWithSegmentedObjects:self.searchData templatePredicate:self.searchPredicate];
}

- (void)setSearchData:(NSArray *)searchData
{
    if (_searchData == searchData)
        return;
    _searchData = searchData;
    self.compoundPredicateFilter = [CVCompoundPredicateFilter compoundFilterWithSegmentedObjects:searchData templatePredicate:self.searchPredicate];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    void (^completionHandler)(NSArray *filteredResults) = ^(NSArray *filteredResults) {
        self.objects = filteredResults;
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
        self.objects = filteredResults;
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
    if (!self.shouldDismissHandler || self.shouldDismissHandler(object, indexPath))
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
