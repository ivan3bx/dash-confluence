//
//  RecentChangeTableViewCell.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentChange.h"

@interface RecentChangeTableViewCell : UITableViewCell {
	IBOutlet UILabel *title;
	IBOutlet UILabel *author;
	IBOutlet UILabel *date;
	
	RecentChange *data;
}
@property(readonly) UILabel *title, *author, *date;
@property(readwrite,assign) RecentChange *dataSource;

@end
