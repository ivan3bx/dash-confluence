//
//  WikiPage.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WikiPage.h"


@implementation WikiPage
@synthesize title, pageId, contentHREF, children;

- (id) initWithDictionary: (NSDictionary *)dict {
	self = [super init];
	if (self != nil) {
		children    = [[NSMutableArray alloc] init];
		title       = [[dict valueForKey:@"text"] retain];
		pageId      = [[dict valueForKey:@"pageId"] retain];
		pageClass   = [[dict valueForKey:@"nodeClass"] retain];
		linkClass   = [[dict valueForKey:@"linkClass"] retain];
		contentHREF = [[dict valueForKey:@"href"] retain];
	}
	return self;
}

- (BOOL) hasChildren {
	return ![pageClass isEqualToString:@""];
}

- (BOOL) isHome {
	return [linkClass isEqualToString:@"home-node"];
}

- (void)addPage: (WikiPage *)page {
	[children addObject:page];
}

- (NSString *) pageChildrenURL {
	return [NSString stringWithFormat: @"/pages/children.action?pageId=%@", pageId];
}
- (NSString *) description {
	return [NSString stringWithFormat:@"Wiki Page [pageId: %@] [title: %@] [contentHREF: %@]", pageId, title, contentHREF];
}

- (void) dealloc {
	[children release];
	[title release];
	[pageId release];
	[pageClass release];
	[linkClass release];
	[contentHREF release];
	[super dealloc];
}

@end
