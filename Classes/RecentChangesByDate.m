//
//  RecentChangesByDate.m
//  Changes
//
//  Created by Ivan Moscoso on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RecentChangesByDate.h"

NSString * const SECTION_TODAY		= @"today";
NSString * const SECTION_YESTERDAY	= @"yesterday";
NSString * const SECTION_RECENT		= @"other";

@implementation RecentChangesByDate

- (id)initWithRecentChanges:(NSArray *)data {
	self = [super init];
	if (self != nil) {
		sectionTitles = [[NSMutableArray alloc] init];
		sectionContent = [[NSMutableArray alloc] init];
		
		NSMutableDictionary *changesBySection = [[NSMutableDictionary alloc] init];
		[changesBySection setValue:[[[NSMutableArray alloc] init] autorelease] forKey:SECTION_TODAY];
		[changesBySection setValue:[[[NSMutableArray alloc] init] autorelease] forKey:SECTION_YESTERDAY];
		[changesBySection setValue:[[[NSMutableArray alloc] init] autorelease] forKey:SECTION_RECENT];
		
		BOOL hasToday = NO, hasYesterday = NO, hasRecent = NO;
		
		for (RecentChange *item in data) {
			if ([item publishedToday]) {
				hasToday = YES;
				[[changesBySection objectForKey:SECTION_TODAY] addObject:item];
			} else if ([item publishedYesterday]) {
				hasYesterday = YES;
				[[changesBySection objectForKey:SECTION_YESTERDAY] addObject:item];
			} else {
				hasRecent = YES;
				[[changesBySection objectForKey:SECTION_RECENT] addObject:item];
			}
		}
		
		if (hasToday) {
			[sectionTitles addObject:NSLocalizedString(@"Today", @"Section heading for main display")];
			[sectionContent addObject:[changesBySection objectForKey:SECTION_TODAY]];
		}
		if (hasYesterday) {
			[sectionTitles addObject:NSLocalizedString(@"Yesterday", @"Section heading for main display")];
			[sectionContent addObject:[changesBySection objectForKey:SECTION_YESTERDAY]];
		}
		if (hasRecent) {
			[sectionTitles addObject:NSLocalizedString(@"Recent", @"Section heading for main display")];
			[sectionContent addObject:[changesBySection objectForKey:SECTION_RECENT]];
		}
		[changesBySection release];

	}
	return self;
}

- (void) dealloc {
	[sectionTitles release];
	[sectionContent release];
	[super dealloc];
}

- (NSInteger)numberOfSections {
	return [sectionContent count];
}

- (NSString *)nameForSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfChangesInSection:(NSInteger)section {
	return [[sectionContent objectAtIndex:section] count];
}

- (RecentChange *)itemInSection:(NSInteger)section row:(NSInteger)row {
	NSArray *content = [sectionContent objectAtIndex:section];
	return [content objectAtIndex:row];
}

@end
