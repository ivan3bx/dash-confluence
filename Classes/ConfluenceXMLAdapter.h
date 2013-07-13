//
//  ConfluenceXMLAdapter.h
//  Changes
//
//  Created by Ivan Moscoso on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"

@interface ConfluenceXMLAdapter : NSObject {
	NSString *authToken;
	NSURL *url;
	id delegate;
}

/*
 * Constructs a new instance.  Will invoke a single synchronous call to get an auth token
 */
-(id)initWith:(UserInfo *)userInfo delegate:(id)delegate;

/*
 * Returns true if this adapter can successfully connect, false otherwise
 */
-(BOOL)isValid;

/*
 * Loads space information.
 * see ConfluenceXMLAdapterDelegate#adapter:receivedSpaceNames:
 */
-(void)loadSpaceInfo;

@end


@protocol ConfluenceXMLAdapterDelegate
@optional

/*
 * Will notify whether or not the adapter is able to connect
 */
-(void)adapter:(ConfluenceXMLAdapter *)adapter didConnect:(BOOL)value;

/*
 * Called when adapter receives space information
 */
-(void)adapter:(ConfluenceXMLAdapter *)adapter receivedSpaceNames:(NSArray *)names;

@end