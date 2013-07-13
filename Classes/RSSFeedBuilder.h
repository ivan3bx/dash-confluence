//
//  RSSFeedBuilder.h
//  Changes
//
//  Created by Ivan Moscoso on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

extern NSString * const DASH_RSS_DEFAULT_FEED;
extern NSString * const DASH_RSS_LAST_CHANGE;

@interface RSSFeedBuilder : NSObject {

}

/*
 * Build an RSS feed string for the currently
 * selected host / uri in the system
 */
- (NSString *)buildFeed;

@end
