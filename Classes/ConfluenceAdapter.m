//
//  ConfluenceAdapter.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ConfluenceAdapter.h"
#import "Constants.h"
#import "UserInfo.h"
#import "ConfluenceRequestDelegate.h"

@implementation ConfluenceAdapter
@synthesize cachePolicy;

- (id) init {
	self = [super init];
	if (self != nil) {
		// Default cache policy
		cachePolicy = NSURLRequestReturnCacheDataElseLoad;
	}
	return self;
}

- (void) dealloc {
	[activeConnection release];
	[delegate release];
	[super dealloc];
}

- (void) fetchDataFor:(NSString *)relativeURL forUser:(UserInfo *)userInfo target:(id)obj selector:(SEL)selector {
	NSURLRequest *request;
	
	if (delegate) {
		[delegate release];
	}
	
	[self cancelActiveConnection];
	
	delegate = [[ConfluenceRequestDelegate alloc] initWithTarget:obj andSelector:selector];
	
	request = [userInfo requestForURL:relativeURL cachePolicy:cachePolicy];
	
	NSLog(@"ConfluenceAdapter prepared to access URL: %@", [[request URL] absoluteString]);
	
	activeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}

- (void) fetchDataFor:(NSString *)relativeURL target:(id)obj selector:(SEL)sel {
	[self fetchDataFor:relativeURL forUser:[UserInfo current] target:obj selector:sel];
}

- (void)cancelActiveConnection {
	if (activeConnection) {
		[activeConnection cancel];
		[activeConnection release];
		activeConnection = nil;
	} else {
		NSLog(@"ConfluenceAdapter: Nothing to cancel (no active connection)");
	}
}

@end
