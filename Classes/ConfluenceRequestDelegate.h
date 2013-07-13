//
//  ConfluenceRequestDelegate.h
//  Changes
//
//  Created by Ivan Moscoso on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ConfluenceRequestDelegate : NSObject {
	id currentTarget;
	SEL currentSelector;
	NSMutableData *responseData;
}

- (id)initWithTarget:(id)obj andSelector:(SEL)sel;

@end
