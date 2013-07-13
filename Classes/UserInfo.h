//
//  Credentials.h
//  Changes
//
//  Created by Ivan Moscoso on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject <NSCoding> {
	NSString *siteName;
	NSString *username;
	NSString *password;
	NSString *base;
}

+ (UserInfo *)current;
+ (void)clearAllData;

- (NSURL *)baseHref;
- (NSData *)createAuthData;
- (NSURL *)appendToBaseURL:(NSString *)relativeURL;
- (NSURLRequest *)requestForURL: (NSString *)relativeURL cachePolicy:(NSURLRequestCachePolicy)policy;

- (void)save;

@property(readwrite,retain) NSString *username;
@property(readwrite,retain) NSString *password;
@property(readwrite,retain) NSString *base;
@property(readwrite,retain) NSString *siteName;

@end
