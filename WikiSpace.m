//
//  WikiSpace.h
//  Class keeping track of a known Confluence Space, and allowing
//  query access to track number/size of all spaces.
//
//  Created by Ivan Moscoso on 8/19/09.
//  Copyright 2009 3boxed software. All rights reserved.
//

#import "WikiSpace.h"
#import "UserInfo.h"
#import "XMLRPCConnection.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"

@implementation WikiSpace

@synthesize key, name, type, urlString;

@end
