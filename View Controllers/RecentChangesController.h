//
//  RecentChangesController.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfluenceAdapter.h"
#import "RecentChangeTableViewCell.h"
#import "RecentChangesByDate.h"
#import "RecentChangesByAuthor.h"
#import "RecentChangesBySpace.h"
#import "RSSFeedBuilder.h"

@interface RecentChangesController : UITableViewController {
	IBOutlet UISegmentedControl *sortByControl;
	IBOutlet UIActivityIndicatorView *activityView;
	
	ConfluenceAdapter *confluence;
	RSSFeedBuilder *rssFeed;
	
	RecentChangesByDate *changesByDate;
	RecentChangesByAuthor *changesByAuthor;
	
	id currentlySelectedChanges;
}

- (IBAction)sortResults:(UISegmentedControl *)sender;
- (IBAction)reload;

@end
