//
//  NSString+Extras.m
//  Changes
//
//  Created by Ivan Moscoso on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extras.h"


@implementation NSString (Extras)

- (BOOL)isBlank {
	return [@"" isEqualToString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

@end
