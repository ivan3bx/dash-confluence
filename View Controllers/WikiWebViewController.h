//
//  WikiWebViewController.h
//  Changes
//
//  Created by Ivan Moscoso on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentChange.h"

@interface WikiWebViewController : UIViewController {
	RecentChange *item;
	IBOutlet UIWebView *webView;
	
	NSMutableData *tmpData;
	NSString *diffUrl;
}

- (id)initWithRecentChange:(RecentChange *)input;

@end
