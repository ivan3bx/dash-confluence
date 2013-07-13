//
//  DiffWebViewController.h
//  Changes
//
//  Created by Ivan Moscoso on 6/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiffWebViewController : UIViewController {
	IBOutlet UIWebView *webView;
	
	NSMutableData *tmpData;
	NSString *diffUrl;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil diffUrl:(NSString *)relativeUrl;

@end
