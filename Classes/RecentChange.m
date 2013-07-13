//
//  RecentChange.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RecentChange.h"

@interface RecentChange (Private)
- (NSDate *) startOfDay;
@end

@implementation RecentChange
@synthesize title, author, urlString, publishDate;
@dynamic publishedLastMinute, publishedLastHour, publishedToday, publishedYesterday, publishedLastWeek;

+(NSArray *) parseRecentChanges: (CXMLDocument *)document {
	NSDictionary *ns = [NSDictionary dictionaryWithObjectsAndKeys:
						@"http://www.w3.org/2005/Atom", @"atom",
						@"http://purl.org/dc/elements/1.1/", @"dc",
						nil];

	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];

	NSError *error;
	NSArray *allEntries = [document nodesForXPath:@"//atom:entry" namespaceMappings:ns error:&error];
	
	// TODO: Group recent changes by wiki space?
	// TODO: Throttle # of recent changes returned based on network speed?

	// Need to set timezone manually for iPhoneOS2.0.  'Z' timezone format string is not recognized.
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	
	for (CXMLElement *entry in allEntries) {
		NSArray *urlNodes		= [entry nodesForXPath:@"atom:link/@href" namespaceMappings:ns error:&error];
		NSArray *titleNodes		= [entry nodesForXPath:@"atom:title/text()" namespaceMappings:ns error:&error];
		NSArray *publishedNodes	= [entry nodesForXPath:@"atom:published/text()" namespaceMappings:ns error:&error];
		NSArray *authorNodes	= [entry nodesForXPath:@"atom:author/atom:name/text()" namespaceMappings:ns error:&error];
		
		NSString *url       = [authorNodes count] > 0 ? [[urlNodes objectAtIndex:0] stringValue] : @"";
		NSString *title     = [titleNodes count] > 0 ? [[titleNodes objectAtIndex:0] stringValue] : NSLocalizedString(@"< Blank >", @"Default title when not specified in RSS");
		NSString *published = [publishedNodes count] > 0 ? [[publishedNodes objectAtIndex:0] stringValue] : @"";
		NSString *author    = [authorNodes count]> 0 ? [[authorNodes objectAtIndex:0] stringValue] : NSLocalizedString(@"Unknown", @"Default label when author is unknown");
		
		NSDate *parsedDate = [dateFormat dateFromString:published];
		
		RecentChange *change = [[RecentChange alloc] initWithTitle:title author:author url:url date:parsedDate];
		[results addObject:change];
		[change release];
	}
	return results;
}

-(id) initWithTitle:(NSString *)titleData author:(NSString *)authorData url:(NSString *)urlData date:(NSDate *)dateData {
	if (self = [super init]) {
		title       = [titleData retain];
		author      = [authorData retain];
		urlString	= [urlData retain];
		publishDate = [dateData retain];
	}
	return self;
}

-(NSString *)publishDateAsString {
	if (cachedDateAsString != nil) {
		return cachedDateAsString;
	}
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	
	//
	// Do some pretty-printing logic for dates within the past few hours
	//
	NSTimeInterval secondsSinceNow = -[publishDate timeIntervalSinceNow];
	
	if ([self publishedLastMinute]) {
		//
		// Less than 1 minute ago
		//
		cachedDateAsString = [NSString localizedStringWithFormat:@"%d seconds ago", (int)(secondsSinceNow)];
	} else if (secondsSinceNow < 100) {
		//
		// Less than ~2 minute
		//
		cachedDateAsString = NSLocalizedString(@"1 minute ago", @"Period of time describes age of an article");
	} else if ([self publishedLastHour]) {
		//
		// Less than 1 hour ago
		//
		cachedDateAsString = [NSString localizedStringWithFormat:@"%d minutes ago", (int)(secondsSinceNow / 60)];
	} else if (secondsSinceNow < 7200) {
		//
		// Less than 2 hours ago
		//
		cachedDateAsString = NSLocalizedString(@"1 hour ago", @"Period of time describes age of an article");
	} else if (secondsSinceNow < 21600) {
		//
		// Less than 12 hours ago
		//
		int hours = (int)(secondsSinceNow / 3600);
		int minutes = (int)(secondsSinceNow / 60) - (hours * 60);
		
		if (minutes > 40) {
			// Roughly, if passed the +40 minute mark, add an hour..
			hours++;
		}
		cachedDateAsString = [NSString localizedStringWithFormat:@"%d hours ago", hours, minutes];
	} else if ([self publishedToday]) {
		//
		// Today
		//
		[formatter setDateStyle:NSDateFormatterNoStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		cachedDateAsString = [NSString localizedStringWithFormat:@"Today at %@", [formatter stringFromDate:publishDate]];
	} else if ([self publishedYesterday]) {
		//
		// Yesterday
		//
		[formatter setDateStyle:NSDateFormatterNoStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		cachedDateAsString = [NSString localizedStringWithFormat:@"Yesterday at %@", [formatter stringFromDate:publishDate]];
	} else if ([self publishedLastWeek]){
		//
		// Default printing of full date / time
		//
		[formatter setDateFormat:@"EEEE',' hh:mm a"];
		cachedDateAsString = [formatter stringFromDate:publishDate];
	} else {
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		cachedDateAsString = [formatter stringFromDate:publishDate];
	}
	return [cachedDateAsString retain];
}

- (NSURL *)url {
	return [NSURL URLWithString:urlString];
}

- (BOOL) publishedLastMinute {
	NSTimeInterval secondsSinceNow = -[publishDate timeIntervalSinceNow];
	return secondsSinceNow < 60;
}

- (BOOL) publishedLastHour {
	NSTimeInterval secondsSinceNow = -[publishDate timeIntervalSinceNow];
	return secondsSinceNow < 3600;
}

- (BOOL) publishedToday {
	BOOL value = [publishDate timeIntervalSinceDate:[self startOfDay]] >= 0;
	return value;
}

- (BOOL) publishedYesterday {
	BOOL value = -([publishDate timeIntervalSinceDate:[self startOfDay]]) < 86400;
	return value;
}

- (BOOL) publishedLastThreeDays {
	BOOL value = -([publishDate timeIntervalSinceDate:[self startOfDay]]) < (86400 * 3);
	return value;
}

- (BOOL) publishedLastWeek {
	BOOL value = -([publishDate timeIntervalSinceDate:[self startOfDay]]) < (86400 * 7);
	return value;
}

- (NSDate *)startOfDay {
	unsigned ymdUnits = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *ymd = [[NSCalendar currentCalendar] components:ymdUnits fromDate:[NSDate date]];
	NSDate *startOfDay = [[NSCalendar currentCalendar] dateFromComponents:ymd];
	return startOfDay;
}

- (void) dealloc {
	[title release];
	[author release];
	[urlString release];
	[publishDate release];
	[cachedDateAsString release];
	[super dealloc];
}

@end
