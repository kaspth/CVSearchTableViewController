//
//  CVSearchViewController.h
//  Copyright (c) 2013 Kasper Timm Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVArrayTableViewController.h"

///@brief Posted when the view is loading.
///@discussion Useful to set properties in a decoupled manner. The notification object is the search table view controller needing data. Set the objects on searchResultsDataSource here or get nothing to be shown.
extern NSString * const CVSearchTableViewControllerLoadDataNotification;

///@param object The object for the cell the user selected.
///@param indexPath The indexPath of the selected cell.
///@return YES if the searchTableViewController should dismiss, NO otherwise. The controller will dismiss by default.
typedef BOOL(^CVSearchDismissBlock)(id object, NSIndexPath *indexPath);

@interface CVSearchTableViewController : CVArrayTableViewController

/**
 @brief Configure the tableView via this.
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

///@brief The data to search through.
@property (nonatomic, strong) NSArray *searchData;

///@brief The predicate used for searching through searchData.
///@discussion Use $searchTerm to reference the users search term.
@property (nonatomic, strong) NSPredicate *searchPredicate;

///@discussion The controller will dismiss if this is not set.
@property (nonatomic, copy) CVSearchDismissBlock willDismissWithPickHandler;

@end
