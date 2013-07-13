//
//  HomeViewController.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/21/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "HomeViewController.h"
#import "RecentChange.h"
#import "UserInfo.h"
#import "WikiWebViewController.h"

@implementation HomeViewController

- (void)viewDidLoad {
	// Always register this observer.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showContent:) name:@"showContent" object:nil];

	UserInfo *userInfo = [UserInfo current];
	if (!userInfo) {
		// First time opening this application
		reloadDataOnNextView = YES;
		[[self navigationController] presentModalViewController:settingsController animated:NO];
		return;
	}
	
	[recentChangesController reload];
}

- (IBAction) editPreferences:(id)sender {
	reloadDataOnNextView = YES;
	[[self navigationController] presentModalViewController:settingsController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	if (reloadDataOnNextView) {
		reloadDataOnNextView = NO;
		[recentChangesController reload];
	}

	// Delegate to controller actually responsible for displaying recent changes
	[recentChangesController viewWillAppear:animated];
}

/*
 * This method will handle selection of specific RecentChange.  The logic
 * for the transition is here, since the HomeView collaborates directly 
 * with the UINavigationController.
 *
 * (see 'RecentChangesController#tableView:didSelectRowAtIndexPath:')
 */
- (void)showContent:(NSNotification *)notification {
	RecentChange *item = [notification object];
	
	WikiWebViewController *wvc = [[WikiWebViewController alloc] initWithRecentChange:item];
	[[self navigationController] pushViewController:wvc animated:YES];
	[wvc release];
}

- (void) dealloc {
	[settingsController release];
	[recentChangesController release];
	[super dealloc];
}

@end
