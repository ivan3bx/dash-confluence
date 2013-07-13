//
//  ChangesAppDelegate.m
//  Changes
//
//  Created by Ivan Moscoso on 4/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ChangesAppDelegate.h"
#import "Constants.h"
#import "UserInfo.h"

NSString * const WIKI_SHOW_SPACES = @"WIKI_SHOW_SPACES";
NSString * const WIKI_SHOW_AUTHORS = @"WIKI_SHOW_AUTHORS";
NSString * const WIKI_NUMBER_OF_ARTICLES = @"WIKI_NUMBER_ARTICLES";
NSString * const WIKI_INITIALIZED = @"WIKI_INITIALIZED";

@interface ChangesAppDelegate (Private)
- (void)registerDefaults;
- (void)resetKeychainIfNecessary;
@end

@implementation ChangesAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self registerDefaults];
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

- (void)registerDefaults {
	NSMutableDictionary *defaults = [[[NSMutableDictionary alloc] init] autorelease];
	[defaults setObject:@"YES" forKey:WIKI_SHOW_SPACES];
	[defaults setObject:@"YES" forKey:WIKI_SHOW_AUTHORS];
	[defaults setObject:@"NO" forKey:WIKI_INITIALIZED];
	
	[defaults setObject:[NSNumber numberWithInt:20] forKey:WIKI_NUMBER_OF_ARTICLES];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
	
	[self resetKeychainIfNecessary];
}

- (void)resetKeychainIfNecessary {
	NSString *currentInitValue = [[NSUserDefaults standardUserDefaults] objectForKey:WIKI_INITIALIZED];
	if ([@"NO" isEqualToString:currentInitValue]) {
		[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:WIKI_INITIALIZED];
		[UserInfo clearAllData];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
