//
//  RecentChangesByAuthor.h
//  Changes
//
//  Created by Ivan Moscoso on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecentChange.h"

@interface RecentChangesByAuthor : NSObject {
	NSArray *changes;
	NSMutableDictionary *changesByAuthor;
	NSMutableArray *authors;
}

- (id)initWithRecentChanges:(NSArray *)data;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfChangesInSection:(NSInteger)section;
- (NSString *)nameForSection:(NSInteger)section;
- (RecentChange *)itemInSection:(NSInteger)section row:(NSInteger)row;

@end
