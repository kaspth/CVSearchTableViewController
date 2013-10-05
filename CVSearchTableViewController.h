//
//  CVSearchViewController.h
//  Copyright (c) 2013 Kasper Timm Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVTableViewArrayDataSource.h"

///@brief Posted when the view is loading.
///@discussion Useful to set properties in a decoupled manner. The notification object is the search table view controller needing data. Set the objects on searchResultsDataSource here or get nothing to be shown.
extern NSString * const CVSearchTableViewControllerLoadDataNotification;

///@param Object The object for the cell the user selected.
///@param indexPath The indexPath of the selected cell.
typedef void(^CVSearchDismissBlock)(id object, NSIndexPath *indexPath);

@interface CVSearchTableViewController : UITableViewController

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
@property (nonatomic, readonly) CVTableViewArrayDataSource *searchResultsDataSource;

///@brief The data to search through.
@property (nonatomic, strong) NSArray *searchData;

///@brief The predicate used for searching through searchData.
///@discussion Use $searchTerm to reference the term to search for.
@property (nonatomic, strong) NSPredicate *searchPredicate;

@property (nonatomic, copy) CVSearchDismissBlock willDismissWithPickHandler;

@end
