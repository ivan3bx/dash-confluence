//
//  WikiSpace.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WikiSpace.h"

@implementation WikiSpace

@synthesize key, title;

- (id) initWithSpaceKey: (NSString *)wikiKey title:(NSString *)wikiName {
	self = [super init];
	if (self != nil) {
		adapter = [[ConfluenceAdapter alloc] init];
		key = [wikiKey retain];
		title = [wikiName retain];
		rootPages = [[NSMutableArray alloc] init];
	}
	return self;
}

-(NSString *)pageChildrenURL {
	return [NSString stringWithFormat: @"/pages/children.action?spaceKey=%@&node=root", key];
}

- (void)addPage: (WikiPage *)page {
	[rootPages addObject:page];
}

- (NSArray *)pages {
	return rootPages;
}

- (WikiPage *)findHomeIn: (NSArray *)pages {
	WikiPage *result = nil;
	for (WikiPage *page in pages) {
		if ([page isHome]) {
			return page;
		}
		if ([page hasChildren]) {
			result = [self findHomeIn: [page children]];
		}
		if (result != nil) {
			return result;
		}
	}
	return result;
}

- (WikiPage *)home {
	return [self findHomeIn:rootPages];
}

- (void) dealloc {
	[rootPages release];
	[key release];
	[title release];
	[super dealloc];
}

@end
