//
//  WikiWebViewController.m
//  Changes
//
//  Created by Ivan Moscoso on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WikiWebViewController.h"
#import "UserInfo.h"
#import "RegexKitLite.h"
#import "DiffWebViewController.h"

@implementation WikiWebViewController

- (id)initWithRecentChange:(RecentChange *)input {
	self = [super initWithNibName:@"WikiWebView" bundle:[NSBundle mainBundle]];
	if (self != nil) {
		item = [input retain];
		[[self navigationItem] setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease]];
	}
	return self;
}

- (void)viewDidLoad {
	// Start spinner
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	UserInfo *userInfo = [UserInfo current];
	
	// Set title
	self.navigationItem.title = item.title;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Show Diff" 
																			   style:UIBarButtonItemStylePlain 
																			  target:self 
																			  action:@selector(showDiff)] autorelease];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	//
	// Construct the URL string
	//
	NSString *urlstring;
	if ([[item urlString] rangeOfString:@"?"].length > 0) {
		urlstring = [[item urlString] stringByAppendingString:@"&decorator=none"];
	} else {
		urlstring = [[item urlString] stringByAppendingString:@"?decorator=none"];
	}
	
	NSLog(@"Requesting content for URL string: %@", urlstring);
	NSURLRequest *req = [userInfo requestForURL:urlstring cachePolicy:NSURLRequestReturnCacheDataElseLoad];
	
	[NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)showDiff {
	[self.navigationController pushViewController:[[[DiffWebViewController alloc] initWithNibName:@"WikiWebView" bundle:nil diffUrl:diffUrl] autorelease] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[webView release];
	[item release];
	[diffUrl release];
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType != UIWebViewNavigationTypeOther) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Browse in Safari?" 
														message:@"Would you like to view the current page in Safari?"
													   delegate:self 
											  cancelButtonTitle:@"No"
											  otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];
		return NO;
	}
	return YES;
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods
#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		[[UIApplication sharedApplication] openURL:[item url]];
	}
}


#pragma mark -
#pragma mark NSURLConnectionDelegate methods
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!tmpData) {
		tmpData = [[NSMutableData alloc] initWithData:data];
	} else {
		[tmpData appendData:data];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UserInfo *currentUserData = [UserInfo current];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSString *htmlContent = [[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding] autorelease];

	//
	// Attempt to capture 'diff' URL, if possible
	//
	diffUrl = [[htmlContent stringByMatching:@"pages/diffpages.action\\?pageId=\\d+&originalId=\\d+"] retain];
	self.navigationItem.rightBarButtonItem.enabled = (diffUrl != nil);
	
	//
	// We presume that the first 'wiki-content' <div> represents the only content we will show.
	// All previous content or following content (header/footer) will be axed
	//
	NSArray *components = [htmlContent captureComponentsMatchedByRegex:@"(?ms:.*?(<div class=\"wiki-content\".*))"];
	htmlContent = [components objectAtIndex:1];
	
	//
	// Parse through content, removing everything after the matching </div> tag which closes our wiki-content
	//
	int counter = 1;
	NSRange selectedRange = NSMakeRange(1, [htmlContent length] - 1);
	while (counter != 0) {
		NSRange nextOpenTag = [htmlContent rangeOfRegex:@"<div.*?>" inRange:selectedRange];
		NSRange nextClosedTag = [htmlContent rangeOfRegex:@"</div>" inRange:selectedRange];
		
		if (nextOpenTag.location == NSNotFound && nextClosedTag.location == NSNotFound) {
			//
			// This considers the case where we have improperly balanced open/close tags.
			// without this check, it's possible for counter to never == 0
			//
			NSLog(@"Unbalanced open/close tags in wiki content");
			break;
		} else if (nextOpenTag.length > 0 && nextOpenTag.location < nextClosedTag.location) {
			selectedRange = NSMakeRange(nextOpenTag.location + nextOpenTag.length, selectedRange.length - (nextOpenTag.location + nextOpenTag.length - selectedRange.location));
			counter++;
		} else {
			selectedRange = NSMakeRange(nextClosedTag.location + nextClosedTag.length, selectedRange.length - (nextClosedTag.location + nextClosedTag.length - selectedRange.location));
			counter--;
		}
	}

	[webView loadHTMLString:[htmlContent substringToIndex:selectedRange.location] baseURL:[currentUserData baseHref]];
	[tmpData release];
	tmpData = nil;
}


@end
