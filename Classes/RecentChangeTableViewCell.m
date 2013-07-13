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

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (RecentChange *)dataSource {
	return data;
}

- (void)setDataSource: (RecentChange *)dataSource {
	data = dataSource;
	author.text = dataSource.author;
	title.text = dataSource.title;
	date.text = [dataSource publishDateAsString];
}

- (void)dealloc {
    [super dealloc];
}


@end
