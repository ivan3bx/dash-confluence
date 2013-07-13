//
//  WikiSiteValidator.h
//  Changes
//
//  Created by Ivan Moscoso on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfluenceAdapter.h"
#import "RSSFeedBuilder.h"
#import "UserInfo.h"

@protocol WikiSiteValidatorDelegate
-(void)didPassWithURL:(NSURL *)url;
-(void)didFailWithError:(NSError *)error;
@end


@interface WikiSiteValidator : NSObject<UIWebViewDelegate> {
	id<WikiSiteValidatorDelegate> delegate;
	ConfluenceAdapter *confluence;
	RSSFeedBuilder *rss;
	
	UIWebView *offscreenWebView;
	UserInfo *userInfoToValidate;
	BOOL validatorTimerExpired;
}

-(id)initWithDelegate:(id<WikiSiteValidatorDelegate>)aDelegate;
-(void)validate:(NSURL *)url user:(NSString *)optionalUser password:(NSString *)optionalPassword;
-(void)cancel;
-(void)expireTimer;

@end
