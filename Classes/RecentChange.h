//
//  RecentChange.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CXMLDocument.h"
#import "CXMLNode_XPathExtensions.h"

@interface RecentChange : NSObject {
	NSString *title;
	NSString *author;
	NSString *urlString;
	NSDate *publishDate;
	NSString *cachedDateAsString;
}

+(NSArray *) parseRecentChanges: (CXMLDocument *)document;

- (id) initWithTitle:(NSString *)titleData author:(NSString *)authorData url:(NSString *)urlData date:(NSDate *)dateData;
- (NSString *)publishDateAsString;
- (NSURL *)url;

@property(readonly) NSString *title, *author, *urlString;
@property(readonly) NSDate *publishDate;

@property(readonly) BOOL publishedLastMinute;
@property(readonly) BOOL publishedLastHour;
@property(readonly) BOOL publishedToday;
@property(readonly) BOOL publishedYesterday;
@property(readonly) BOOL publishedLastThreeDays;
@property(readonly) BOOL publishedLastWeek;

@end
