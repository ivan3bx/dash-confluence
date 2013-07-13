//
//  HomeViewController.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/21/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentChangesController.h"

@interface HomeViewController : UIViewController {
	IBOutlet UINavigationController *settingsController;
	
	IBOutlet RecentChangesController *recentChangesController;
	IBOutlet UIView *content;
	IBOutlet UIButton *prefsButton;
	
	BOOL reloadDataOnNextView;
}

- (IBAction) editPreferences:(id)sender;
@end
