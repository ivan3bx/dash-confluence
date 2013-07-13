//
//  RecentChangeTableViewCell.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RecentChangeTableViewCell.h"


@implementation RecentChangeTableViewCell

@synthesize author, title, date;

- (RecentChange *)dataSource {
	return data;
}

- (void)setDataSource: (RecentChange *)dataSource {
	[author setMinimumFontSize:author.font.pointSize];
	[title setMinimumFontSize:title.font.pointSize];
	[date setMinimumFontSize:date.font.pointSize];
	
	data = dataSource;
	author.text = dataSource.author;
	title.text = dataSource.title;
	date.text = [dataSource publishDateAsString];
}

- (void)dealloc {
	[title release];
	[author release];
	[date release];
	[data release];
    [super dealloc];
}


@end
