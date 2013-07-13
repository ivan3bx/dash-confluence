//
//  DiffWebViewController.m
//  Changes
//
//  Created by Ivan Moscoso on 6/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DiffWebViewController.h"
#import "UserInfo.h"
#import "RegexKitLite.h"

@implementation DiffWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil diffUrl:(NSString *)relativeUrl {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[[self navigationItem] setTitle:@"Differences"];
        diffUrl = [relativeUrl retain];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	webView.scalesPageToFit = YES;
	
	UserInfo *userInfo = [UserInfo current];

	//
	// Construct the URL string
	//
	NSLog(@"Requesting diff [%@]", diffUrl);
	NSURLRequest *req = [userInfo requestForURL:[diffUrl stringByAppendingString:@"&decorator=none"] 
									cachePolicy:NSURLRequestReturnCacheDataElseLoad];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[NSURLConnection connectionWithRequest:req delegate:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[diffUrl release];
	[webView release];
    [super dealloc];
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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSString *htmlContent = [[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding] autorelease];
	htmlContent = [htmlContent stringByReplacingOccurrencesOfRegex:@"(<a .*?>).*?</a>" withString:@"$1</a>"];
	
	//
	// Parse out diff table
	//
	NSArray *components = [htmlContent captureComponentsMatchedByRegex:@"(?ms:.*?(<table class=\"diff\".*</table>))"];
	htmlContent = [components objectAtIndex:1];
	
	//
	// Add anchor for the first 'diff'
	//
	NSRange locationOfFirstAddition = [htmlContent rangeOfRegex:@"<td class=\"diff.?added.*?>"];
	NSRange locationOfFirstDeletion = [htmlContent rangeOfRegex:@"<td class=\"diff.?deleted.*?>"];
	NSRange locationOfFirstChangedLine = [htmlContent rangeOfRegex:@"<td class=\"diff-changed-lines.*?>"];
	
	//
	// Determine which location is the nearest to the top
	//
	NSRange firstLoc = (locationOfFirstAddition.location < locationOfFirstDeletion.location) ? locationOfFirstAddition : locationOfFirstDeletion;
	firstLoc = (firstLoc.location < locationOfFirstChangedLine.location) ? firstLoc : locationOfFirstChangedLine;
	
	if (firstLoc.location != NSNotFound) {
		//
		// Add anchor if location is present
		//
		htmlContent = [htmlContent stringByReplacingCharactersInRange:NSMakeRange(firstLoc.location + firstLoc.length, 0) withString:@"<a name=\"firstDiff\"/>"];
	}
	
	//
	// Prepend stylesheet
	//
	NSString *minStyle = @"<link href=\"diffstyle.css\" rel=\"stylesheet\" type=\"text/css\">";
	htmlContent = [minStyle stringByAppendingString:htmlContent];
	
	//
	// Prepend javascript which will scroll to first diff on load
	//
	htmlContent = [htmlContent stringByAppendingString:@"<script type=\"text/javascript\"> window.onload = function() { location.hash=\"#firstDiff\"; }</script>"];
	
	[webView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath] isDirectory:YES]];
}
@end
