//
//  RecentChangesBySpace.m
//  Changes
//
//  Created by Ivan Moscoso on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RecentChangesBySpace.h"
#import "RegexKitLite.h"


@implementation RecentChangesBySpace


- (id)initWithRecentChanges:(NSArray *)data {
	self = [super init];
	if (self != nil) {
		changes = [data retain];
		changesBySpace = [[NSMutableDictionary alloc] init];
		spaces = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[changes release];
	[changesBySpace release];
	[spaces release];
	[super dealloc];
}


- (NSInteger)numberOfSections {
	if ([changes count] == 0) {
		// Reset any cached data
		[changesBySpace removeAllObjects];
		[spaces removeAllObjects];
		return 1;
	}
	
	for (RecentChange *item in changes) {
		NSString *spaceKey = [item.urlString stringByMatching:@".*/display/(.*)/.*" capture:1];
		
		// space key can be null if page is direct access.
		// TODO: navigate tree in order to determine space...
		if (spaceKey == nil) {
			continue;
		} if ([changesBySpace objectForKey:spaceKey]) {
			// Existing author
			[[changesBySpace objectForKey:spaceKey] addObject:item];
		} else {
			// First time for this author
			[spaces addObject:spaceKey];
			[changesBySpace setObject:[NSMutableArray arrayWithObject:item] forKey:spaceKey];
		}
	}
	return [changesBySpace count];
}
- (NSInteger)numberOfChangesInSection:(NSInteger)section {
	if ([changesBySpace count] == 0) {
		return 0;
	}
	return [[changesBySpace objectForKey:[spaces objectAtIndex:(section)]] count];
}

- (NSString *)nameForSection:(NSInteger)section {
	if ([spaces count] == 0) {
		return nil;
	}
	
	return [spaces objectAtIndex:(section)];
}

- (RecentChange *)itemInSection:(NSInteger)section row:(NSInteger)row {
	NSString *spaceName = [spaces objectAtIndex:(section)];
	NSArray *entries = [changesBySpace objectForKey:spaceName];
	
	return [entries objectAtIndex:(row)];
}

@end
