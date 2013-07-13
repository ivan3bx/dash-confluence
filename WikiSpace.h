//
//  WikiSpace.h
//  Class keeping track of a known Confluence Space, and allowing
//  query access to track number/size of all spaces.
//
//  Created by Ivan Moscoso on 8/19/09.
//  Copyright 2009 3boxed software. All rights reserved.
//


@interface WikiSpace : NSObject {
	NSString *key;
	NSString *name;
	NSString *type;
	NSString *urlString;
}

@property(readonly) NSString *key;
@property(readonly) NSString *name;
@property(readonly) NSString *type;
@property(readonly) NSString *urlString;

@end
