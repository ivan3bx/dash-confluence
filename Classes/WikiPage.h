//
//  WikiPage.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WikiContent.h"

@interface WikiPage : NSObject <WikiContent> {
	/* Page attributes */
	NSString *title;
	NSString *pageId;
	NSString *contentHREF;
	NSString *pageClass;
	NSString *linkClass;
	
	/* Children */
	NSMutableArray *children;
}

- (id) initWithDictionary: (NSDictionary *)input;
- (BOOL) hasChildren;
- (BOOL) isHome;
- (void)addPage: (WikiPage *)page;
- (NSString *)pageChildrenURL;

@property(readonly) NSString *title;
@property(readonly) NSString *pageId;
@property(readonly) NSString *contentHREF;
@property(readonly) NSArray *children;
@end
