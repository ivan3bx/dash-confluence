//
//  ConfluenceXMLAdapter.m
//  Changes
//
//  Created by Ivan Moscoso on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConfluenceXMLAdapter.h"
#import "XMLRPCConnection.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "RegexKitLite.h"

@implementation ConfluenceXMLAdapter

-(id)initWith:(UserInfo *)userInfo delegate:(id)delegateObj {
	self = [super init];
	if (self != nil) {
		url = [[NSURL URLWithString:@"/rpc/xmlrpc" relativeToURL:[userInfo baseHref]] retain];
		delegate = delegateObj;
		XMLRPCResponse *response;
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithHost:url];
		[request setMethod:@"confluence1.login" withObjects:[NSArray arrayWithObjects:userInfo.username, userInfo.password, nil]];
		response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
		
		if ([response isKindOfClass:[NSError class]]) {
			NSLog(@"Received error: %@", response);
			authToken = nil;
		} else {
			authToken = [[response source] stringByMatching:@"<value>(.+)</value>" capture:1];
		}
		NSLog(@"Response: %@", authToken);
		[request release];
	}
	return self;
}

-(BOOL)isValid {
	return authToken != nil;
}

-(void)loadSpaceInfo {
	if (![self isValid]) {
		return;
	}

//	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithHost:url];
//	[request setMethod:@"confluence1.getSpaces" withObject: authToken];

	//	XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
//	NSLog(@"Request: %@", [request source]);
//	NSLog(@"Response: %@", [response source]);
}

@end
