//
//  ConfluencePageResolver.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConfluencePageResolver.h"
#import "RegexKitLite.h"

@implementation NSURLConnection (Testable)
- (NSDictionary *) sendSynchronousRequest:(NSURLRequest *)request {
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	return [NSDictionary dictionaryWithObjectsAndKeys:	data, @"data",
														response, @"response",
														error, @"error",
														nil];
}
@end

@implementation ConfluencePageResolver
- (NSString *) resolvePageIdForURL: (NSString *)relativeURL {
	return [self resolvePageIdForURL:relativeURL with:[[[NSURLConnection alloc] init] autorelease]];
}

- (NSString *) resolvePageIdForURL: (NSString *)relativeURL with: (NSURLConnection *)connection {
	NSURLRequest *request = [super prepareRequestFor:[NSString stringWithFormat: @"%@?decorator=none", relativeURL]];
	
	//
	// Send synchronous request
	//
	NSDictionary *results = [connection sendSynchronousRequest:request];
	NSData *data = [results objectForKey:@"data"];
	
	//
	// Parse out response
	//
	NSError *error = nil;
	NSString *rawResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSRange matchedRange = [rawResponse rangeOfRegex:@"href=\"/pages/editpage.action\\?pageId=(\\d+)" 
											 options:RKLNoOptions 
											 inRange:NSMakeRange(0, [rawResponse length]) 
											 capture:1 error:&error];
	
	return [[rawResponse substringWithRange:matchedRange] retain];
}
@end
