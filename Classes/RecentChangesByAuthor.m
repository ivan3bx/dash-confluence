//
//  RecentChangesByAuthor.m
//  Changes
//
//  Created by Ivan Moscoso on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RecentChangesByAuthor.h"


@implementation RecentChangesByAuthor

- (id)initWithRecentChanges:(NSArray *)data {
	self = [super init];
	if (self != nil) {
		changes = [data retain];
		changesByAuthor = [[NSMutableDictionary alloc] init];
		authors = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[changes release];
	[changesByAuthor release];
	[authors release];
	[super dealloc];
}

- (NSInteger)numberOfSections {
	if ([changes count] == 0) {
		return 1;
	} else {
		// Reset any cached data
		[changesByAuthor removeAllObjects];
		[authors removeAllObjects];
	}
	
	for (RecentChange *item in changes) {
		if ([changesByAuthor objectForKey:item.author]) {
			// Existing author
			[[changesByAuthor objectForKey:item.author] addObject:item];
		} else {
			// First time for this author
			[authors addObject:item.author];
			[changesByAuthor setObject:[NSMutableArray arrayWithObject:item] forKey:item.author];
		}
	}
	return [changesByAuthor count];
}

- (NSInteger)numberOfChangesInSection:(NSInteger)section {
	if ([changesByAuthor count] == 0) {
		return 0;
	}
	return [[changesByAuthor objectForKey:[authors objectAtIndex:(section)]] count];
}

- (NSString *)nameForSection:(NSInteger)section {
	if ([authors count] == 0) {
		return nil;
	}
	
	return [authors objectAtIndex:(section)];
}



- (RecentChange *)itemInSection:(NSInteger)section row:(NSInteger)row {
	NSString *authorName = [authors objectAtIndex:(section)];
	NSArray *entries = [changesByAuthor objectForKey:authorName];
	
	return [entries objectAtIndex:(row)];
}



@end
