//
//  ConfluenceRequestDelegate.m
//  Changes
//
//  Created by Ivan Moscoso on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConfluenceRequestDelegate.h"

@interface ConfluenceRequestDelegate (Private)
- (void)completeWithResponse:(NSString *)data;
@end

@implementation ConfluenceRequestDelegate

- (id)initWithTarget:(id)obj andSelector:(SEL)sel {
	self = [super init];
	if (self != nil) {
		// 'target' will be released when connection finishes loading
		currentTarget = [obj retain];
		currentSelector = sel;
	}
	return self;
}

#pragma mark -
#pragma mark == NSURLConnectionDelegate Methods ==
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!responseData) {
		responseData = [[NSMutableData alloc] init];
	}
	[responseData appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	if (redirectResponse) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)redirectResponse;
		NSInteger statusCode = [httpResponse statusCode];
		NSString *redirectLocation = [[httpResponse allHeaderFields] valueForKey:@"Location"];
		
		if (statusCode == 302 && [redirectLocation rangeOfString:@"login.action"].location != NSNotFound) {
			// Being redirected to the login.action means we have invalid credentials. Avoid redirect.
			NSLog(@"Connection delegate asked to redirect for login (invalid credentials?)  Skipping redirect.");
			return nil;
		} else {
			// Default behavior is to allow request or any valid redirects
			NSLog(@"Connection delegate to allow redirect [ %@ ]", [request URL]);
		}
	}
	
	return request;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection did fail with error, %@", [error description]);
	[self completeWithResponse:NULL];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Connection finished loading [%d bytes]", [responseData length]);
	NSString *data = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	[self completeWithResponse:data];
}

- (void)completeWithResponse:(NSString *)data {
	[currentTarget performSelector:currentSelector withObject:data];
	[currentTarget release];

	if (responseData) {
		[responseData release];
		responseData = nil;
	}
}

@end
