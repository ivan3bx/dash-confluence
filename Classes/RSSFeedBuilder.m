//
//  RSSFeedBuilder.m
//  Changes
//
//  Created by Ivan Moscoso on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RSSFeedBuilder.h"
#import "Constants.h"

NSString * const DASH_RSS_DEFAULT_FEED = @"spaces/createrssfeed.action"
										 @"?types=page&spaces=&maxResults=%d&timeSpan=100&publicFeed=false"
										 @"&rssType=atom&showDiff=false&showContent=false";

NSString * const DASH_RSS_LAST_CHANGE = @"spaces/createrssfeed.action"
										@"?types=page&spaces=&maxResults=1&publicFeed=false"
										@"&rssType=atom&showDiff=false&showContent=false";

// Enabling additional content types (comments, blogposts) requires changes to parser
//NSString * const DEFAULT_FEED = @"/spaces/createrssfeed.action"
//								@"?types=page&types=blogpost&types=comment&spaces=&maxResults=%d&publicFeed=false"
//								@"&rssType=atom&showDiff=false&showContent=false";


#pragma mark -
#pragma mark Confluence Content types
#pragma mark -
NSString * const TYPE_PAGE = @"page";
NSString * const TYPE_BLOG = @"blogpost";
NSString * const TYPE_MAIL = @"mail";
NSString * const TYPE_COMMENT = @"comment";
NSString * const TYPE_ATTACHMENT = @"attachment";

NSString * const SORT_MODIFIED = @"modified";
NSString * const SORT_CREATED = @"created";

@implementation RSSFeedBuilder

- (NSString *)buildFeed {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger numberOfArticles = [defaults integerForKey:WIKI_NUMBER_OF_ARTICLES];
	
	NSString *feedURL = [NSString stringWithFormat:DASH_RSS_DEFAULT_FEED, numberOfArticles];
	
	NSLog(@"Resolved RSS feed: %@", feedURL);
	return feedURL;
}

@end
