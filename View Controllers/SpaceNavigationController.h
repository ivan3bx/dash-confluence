//
//  SpaceNavigationController.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfluenceAdapter.h"
#import "WikiSpace.h"
#import "WikiPage.h"

@interface SpaceNavigationController : UITableViewController {
	IBOutlet UIWebView *webView;
	WikiSpace *space;
	WikiPage *currentPage;
}

- (id) initWithContent: (WikiSpace *)input;
- (id) initWithSpace: (WikiSpace *)aSpace atPage: (WikiPage *)aPage;

@end
