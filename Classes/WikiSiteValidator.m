//
//  WikiSiteValidator.m
//  Changes
//
//  Created by Ivan Moscoso on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WikiSiteValidator.h"
#import "RegexKitLite.h"
#import "TouchXML.h"

@implementation WikiSiteValidator

-(id)initWithDelegate:(id<WikiSiteValidatorDelegate>)aDelegate {
	self = [super init];
	if (self) {
		confluence = [[ConfluenceAdapter alloc] init];
		confluence.cachePolicy = NSURLRequestReloadIgnoringCacheData;
		rss = [[RSSFeedBuilder alloc] init];
		delegate = aDelegate;
		userInfoToValidate = [[UserInfo alloc] init];
		validatorTimerExpired = NO;
		offscreenWebView = [[UIWebView alloc] init];
		[offscreenWebView setDelegate:self];
	}
	return self;
}

- (void) dealloc
{
	[userInfoToValidate release];
	[offscreenWebView release];
	[rss release];
	[super dealloc];
}


-(void)validate:(NSURL *)url user:(NSString *)optionalUser password:(NSString *)optionalPassword 
{
	userInfoToValidate.base = [url absoluteString];
	userInfoToValidate.username = optionalUser;
	userInfoToValidate.password = optionalPassword;

	[offscreenWebView loadRequest:[NSURLRequest requestWithURL:url]];
	[self performSelector:@selector(expireTimer) withObject:nil afterDelay:5.0];
}

-(void)parseFeed:(NSString *)input {
	NSError *error = nil;
	CXMLDocument *document = [[[CXMLDocument alloc] initWithXMLString:input options:0 error:&error] autorelease];
	if (document && !error) {
		[delegate didPassWithURL:[userInfoToValidate baseHref]];
	} else {
		NSDictionary *errorData = [NSDictionary dictionaryWithObject:@"Unable to verify settings" 
															  forKey:NSLocalizedDescriptionKey];

		[delegate didFailWithError:[NSError errorWithDomain:@"DASH" 
													   code:1 
												   userInfo:errorData]];
	}
}

-(void)cancel {
	NSLog(@"WikiSiteValidator: Will cancel confluence connection");
	[confluence cancelActiveConnection];
}

-(void)expireTimer {
	validatorTimerExpired = YES;
	if (![offscreenWebView isLoading]) {
		NSString *finalURLString = [offscreenWebView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
		
		// Parse out HREF (remove last section of path if URL does not end in trailing slash)
		if ([[finalURLString componentsSeparatedByString:@"/"] count] > 2) {
			finalURLString = [finalURLString stringByMatching:@"(.*/).*" capture:1];
		}
		
		userInfoToValidate.base = finalURLString;
		[confluence fetchDataFor:DASH_RSS_LAST_CHANGE forUser:userInfoToValidate target:self selector:@selector(parseFeed:)];
		validatorTimerExpired = NO;
	}
}

#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"Validator will load.. %@", [request description]);
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if (validatorTimerExpired) {
		[self expireTimer];
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSDictionary *errorData = [NSDictionary dictionaryWithObject:@"Server is not responding.  Please Check settings and try again." 
														  forKey:NSLocalizedDescriptionKey];
	[delegate didFailWithError:[NSError errorWithDomain:@"DASH" code:1 userInfo:errorData]];
}

@end
