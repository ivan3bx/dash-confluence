//
//  LoadWikiSpace.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WikiSpace.h"
#import "WikiPage.h"
#import "ConfluenceAdapter.h"

@interface LoadWikiSpace : NSOperation 
{
	/* The source root for this operation */
	id <WikiContent>content;

	NSOperationQueue *queue;
	ConfluenceAdapter *adapter;
	BOOL isLoading;
}

/*
 * Initialize with a given WikiSpace.
 * This space can have pages added to it as a result of this operation
 * executing
 */
- (id)initWithSpace: (WikiSpace *)aSpace andQueue:(NSOperationQueue *)queue;

/*
 * Initialize with a given WikiSpace.
 * This space can have pages added to it as a result of this operation
 * executing
 */
- (id)initWithPage: (WikiPage *)aPage andQueue:(NSOperationQueue *)queue;

@end
