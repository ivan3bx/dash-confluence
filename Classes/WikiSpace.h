//
//  WikiSpace.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WikiContent.h"
#import "WikiPage.h"
#import "ConfluenceAdapter.h"

@interface WikiSpace : NSObject <WikiContent> {
	NSString *title;
	NSString *key;
	NSMutableArray *rootPages;
	ConfluenceAdapter *adapter;
}

- (id)initWithSpaceKey:(NSString *)spaceKey title:(NSString *)spaceName;
- (NSString *)pageChildrenURL;
- (WikiPage *)home;
- (void)addPage: (WikiPage *)page;

@property(readonly) NSString *key;
@property(readonly) NSString *title;
@property(readonly) NSArray *pages;

@end
