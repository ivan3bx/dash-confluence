//
//  LoadWikiSpace.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoadWikiSpace.h"
#import "CJSONDeserializer.h"

@implementation LoadWikiSpace

- (id)initWithContent: (id<WikiContent>)aWikiContent andQueue:(NSOperationQueue *)aQueue
{
	self = [super init];
	if (self != nil) {
		content = aWikiContent;
		queue = aQueue;
		adapter = [[ConfluenceAdapter alloc] init];
	}
	return self;
}

- (id)initWithSpace: (WikiSpace *)aSpace andQueue:(NSOperationQueue *)aQueue {
	return [self initWithContent:aSpace andQueue:aQueue];
}

- (id)initWithPage: (WikiPage *)aPage andQueue:(NSOperationQueue *)aQueue {
	return [self initWithContent:aPage andQueue:aQueue];
}


- (void)main
{
	NSString *url = [content pageChildrenURL];
	SEL targetSelector = @selector(appendChildren:);
	
	isLoading = YES;
	[adapter fetchDataFor: url target:self selector:targetSelector];
	// execute the run loop until the queue is empty
	NSRunLoop *loop = [NSRunLoop currentRunLoop];
	while (isLoading  && [loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);	
}


- (void)appendChildren: (NSString *)jsonData
{
	isLoading = NO;
	NSError *error;
	CJSONDeserializer *deserializer = [[[CJSONDeserializer alloc] init] autorelease];
	NSArray *data = [deserializer deserialize:[jsonData dataUsingEncoding:NSUTF8StringEncoding] error:&error];
	
	for (NSDictionary *item in data) {
		NSString *linkClass = [item objectForKey:@"linkClass"];
		
		//
		// Special case as seen on Atlassian's Confluence site.  Certain pages exist that contain
		// metadata about the Space itself.  For purposes of the browser, we ignore these
		//
		NSString *title = [item objectForKey:@"text"];
		if ([title isEqualToString:@"_InclusionsLibrary"] || [title isEqualToString:@".bookmarks"]) {
			continue;
		}
		
		//
		// Only display pages which are page-nodes or home nodes
		//
		if ([linkClass isEqualToString:@"page-node"] || [linkClass isEqualToString:@"home-node"]) {
			
			/* Allocate a new page for this node */
			WikiPage *page = [[WikiPage alloc] initWithDictionary:item];
			
			/* Recurse if this page has child nodes */
			if ([page hasChildren]) {
				[queue addOperation:[[[LoadWikiSpace alloc] initWithPage:page andQueue: queue] autorelease]];
			}
			
			[content addPage:page];
		}
		
	}
}

@end
