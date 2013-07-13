//
//  ConfluencePageResolver.h
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConfluenceAdapter.h"

@interface ConfluencePageResolver : ConfluenceAdapter { }
/*
 * Given a relative URL, returns the page ID that should be displayed.
 * In the event of the URL referring to a 'Space', will return the home page's pageID
 * for that space.
 */
- (NSString *) resolvePageIdForURL: (NSString *)relativeURL;
@end


/*
 * Addition to NSURLConnection allows support for better testing
 */
@interface NSURLConnection (Testable)
- (NSDictionary *) sendSynchronousRequest:(NSURLRequest *)request;
@end

/*
 * Addition to support better testing
 */
@interface ConfluencePageResolver (Testable)

- (NSString *) resolvePageIdForURL: (NSString *)relativeURL 
							  with:(NSURLConnection *)connection;
@end
