//
//  EditWikiViewController.h
//  Changes
//
//  Created by Ivan Moscoso on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceTextFieldGroup.h"
#import "WikiSiteValidator.h"
#import "WikiSiteValidatorBarButtonItem.h"

@interface EditWikiViewController : UITableViewController<WikiSiteValidatorDelegate> {
	
	NSArray *detailCells;
	BOOL keyboardIsShowing;
	WikiSiteValidator *validator;
	
	IBOutlet UIBarButtonItem				*cancelButton;
	IBOutlet UIBarButtonItem				*saveButton;
	IBOutlet WikiSiteValidatorBarButtonItem *saveProgressItem;
	
	// Account settings
	IBOutlet UITableViewCell	*serverCell;
	IBOutlet UITableViewCell	*accountCell;
	IBOutlet UITableViewCell	*passwordCell;
	
	// Number of articles to fetch
	IBOutlet UITableViewCell	*selectSizeCell;
	IBOutlet UISegmentedControl *selectSizeControl;	

	IBOutlet PreferenceTextFieldGroup *textFields;
}

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)saveSizeOfFeed:(UISegmentedControl *)sender;

@end
