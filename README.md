CVSearchTableViewController
===========================

A table view controller and a search bar meets pain free setting up and filtering of search strings.

## Usage

Add the dependency to your `Podfile`:

```ruby
platform :ios # or :osx
pod 'CVPredicateFilter'
...
```

Run pod install to install the dependencies.

### CVSearchTableViewController

`CVSearchTableViewController` uses both [`CVTableViewArrayDataSource`](https://github.com/kaspth/CVTableViewArrayDataSource) and [`CVPredicateFilter`](https://github.com/kaspth/CVPredicateFilter) to help it be as pain free as possible.

You can setup your table view controller in a storyboard or subclass `CVSearchTableViewController` and override loadView.
Note: the `searchDisplayController` has it's `displaysSeachBarInNavigationBar` property set to YES.

Use `CVSearchTableViewControllerLoadDataNotification`, which the search table view controller posts when it's view did load, to setup the controller from any class. Like so:

```objc
#import "CVSearchTableViewController.h"

...

- (void)setupSearchViewController
{
    // remember to release the returned observer value in -dealloc
    id someHandle = [[NSNotificationCenter defaultCenter] addObserverForName:CVSearchTableViewControllerLoadDataNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        CVSearchTableViewController *searchController = (CVSearchTableViewController *)[notification object];
        
        searchController.searchPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] $searchTerm"]; // use $searchTerm to use the users search string.
        searchController.searchData = @[@[@"one", @"two"], @[@"one", @"two"]];
        
        searchController.searchResultsDataSource.cellIdentifier = @"SomeUniqueCellIdentifier";
        searchController.searchResultsDataSource.sections = @[NSLocalizedString(@"Section One", @"The first section"), NSLocalizedString(@"Section Two", @"The second section")];
        searchController.searchResultsDataSource.objects = searchController.searchData;
        searchController.searchResultsDataSource.cellConfigurationHandler = ^(UITableViewCell *cell, NSString *number) {
            cell.textLabel.text = object;
        };
        
        searchController.willDismissWithPickHandler = ^(id object, NSIndexPath *indexPath) {
            // called when the user selects a row in the search table view controller.
        };
    }];
}
```

Just like that, you have got a functioning searchable table view controller!

## Credits

Distributed with an MIT License.

Contributions more than welcome.

Made by Kasper Timm Hansen.
GitHub: [@kaspth](https://github.com/kaspth).
Twitter: [@kaspth](https://twitter.com/kaspth).
