//
//  PreferencesSaveButton.m
//  Changes
//
//  Created by Ivan Moscoso on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WikiSiteValidatorBarButtonItem.h"


@implementation WikiSiteValidatorBarButtonItem

- (id) init
{
	self = [super init];
	if (self != nil) {
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityView setHidden:NO];
		[activityView startAnimating];
		[self setCustomView:activityView];
	}
	return self;
}

- (void) dealloc
{
	[activityView release];
	[super dealloc];
}

@end
