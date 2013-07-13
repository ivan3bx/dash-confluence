//
//  ConfluenceAdapter.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@class UserInfo;
@class ConfluenceRequestDelegate;

@interface ConfluenceAdapter : NSObject {
	
	ConfluenceRequestDelegate* delegate;
	NSURLConnection *activeConnection;
	
	// The cache policy to use for new HTTP requests
	// (will also dictate whether cookies are flushed)
	NSURLRequestCachePolicy cachePolicy;
}

/*
 * Fetches data asynchronously.
 * -   target: the object which will handle the response
 * - selector: selector which will receive the response data as an NSString argument
 */
- (void)fetchDataFor: (NSString *)relativeURL target: (id)obj selector: (SEL)sel;
- (void)fetchDataFor: (NSString *)relativeURL forUser:(UserInfo *)userInfo target:(id)obj selector:(SEL)selector;
- (void)cancelActiveConnection;

@property (readwrite) NSURLRequestCachePolicy cachePolicy;
@end
