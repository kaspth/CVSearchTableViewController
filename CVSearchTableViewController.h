//
//  CVSearchViewController.h
//  Copyright (c) 2013 Kasper Timm Hansen. All rights reserved.
//

#import "CVArrayTableViewController.h"

///@param object The object for the cell the user selected.
///@param indexPath The indexPath of the selected cell.
///@return YES if the searchTableViewController should dismiss, NO otherwise. The controller will dismiss by default.
typedef BOOL(^CVSearchDismissBlock)(id object, NSIndexPath *indexPath);

/**
 @discussion
 Notable properties include
 cellIdentifier
 cellConfigurationHandler
 sections
 objects

 Properties used internally:
 tableViewToDequeueFrom - set to the tableView of the searchTableViewController, since the searchResultsTableView doesn't know about any cells.
 hideHeadersForEmptySections - Set to YES.
 didSelectRowBlock - Use willDismissWithPickHandler.
 */
@interface CVSearchTableViewController : CVArrayTableViewController

///@brief The data to search through.
@property (nonatomic, strong) NSArray *searchData;

///@brief The predicate used for searching through searchData.
///@discussion Use $searchTerm to reference the users search term.
@property (nonatomic, strong) NSPredicate *searchPredicate;

///@discussion The controller will dismiss if this is not set.
@property (nonatomic, copy) CVSearchDismissBlock willDismissWithPickHandler;

@end
