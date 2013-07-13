//
//  Credentials.m
//  Changes
//
//  Created by Ivan Moscoso on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Security/Security.h>
#import "UserInfo.h"
#import "Constants.h"
#import "NSString+Extras.h"

@interface UserInfo(Private)
- (void)populateFromKeychain:(UserInfo *)instance;
- (BOOL)keychainEntryExists;
- (BOOL)deleteFromKeychain;
- (BOOL)addToKeychain;
@end

@implementation UserInfo
@synthesize username, password, siteName, base;

+ (UserInfo *)current {
	UserInfo *info = [[[UserInfo alloc] init] autorelease];
	if ([info keychainEntryExists]) {
		[info populateFromKeychain:info];
		return info;
	} else {
		return nil;
	}
}

+ (void)clearAllData {
	[[UserInfo current] deleteFromKeychain];
}

- (NSURL *)baseHref {
	return [NSURL URLWithString:base];
}

- (NSURL *)appendToBaseURL:(NSString *)relativeURL {
	NSURL *result;
	
	if (relativeURL) {
		result = [NSURL URLWithString: relativeURL relativeToURL: self.baseHref];
	} else {
		result = [self baseHref];
	}
	return result;
}

- (NSData *)createAuthData {
	NSMutableString *postData = [[[NSMutableString alloc] init] autorelease];
	[postData appendFormat:@"os_username=%@", self.username];
	[postData appendFormat:@"&os_password=%@", self.password];
	[postData appendFormat:@"&os_cookie=true"];
	return [postData dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSURLRequest *)requestForURL: (NSString *)relativeURL cachePolicy:(NSURLRequestCachePolicy)cachePolicy {
	if (!cachePolicy) {
		cachePolicy = NSURLRequestReturnCacheDataElseLoad;
	}
	
	NSURL *url = [self appendToBaseURL: relativeURL];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:cachePolicy 
												   timeoutInterval:60.0];
	
	if (cachePolicy == NSURLRequestReloadIgnoringCacheData) {
		[req setHTTPShouldHandleCookies:NO];
	}
	
	if (username) {
		[req setHTTPMethod:@"POST"];
		[req setHTTPBody: [self createAuthData]];
	}
	return req;
}

- (void)populateFromKeychain:(UserInfo *)instance {
	NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
	[queryParams setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[queryParams setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	[queryParams setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	[queryParams setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	NSDictionary *resultData;
	OSStatus result = SecItemCopyMatching((CFDictionaryRef)queryParams, (CFTypeRef *)&resultData);
	if (result == noErr) {
		instance.base = [resultData objectForKey:(id)kSecAttrService];
		
		if ([resultData objectForKey:(id)kSecAttrAccount] && ![[resultData objectForKey:(id)kSecAttrAccount] isBlank]) {
			instance.username = [resultData objectForKey:(id)kSecAttrAccount];
		}

		NSData *passwordData = [resultData objectForKey:(id)kSecValueData];

		if (passwordData) {
			NSString *passwordString = [[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] encoding:NSUTF8StringEncoding];
			instance.password = passwordString;
			[passwordString release];
		}
	}
	[queryParams release];
	[resultData release];
}

- (BOOL)keychainEntryExists {
	NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
	[queryParams setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[queryParams setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	[queryParams setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	[queryParams setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	
	NSMutableDictionary *attributes;
	OSStatus result = SecItemCopyMatching((CFDictionaryRef)queryParams, (CFTypeRef *)&attributes);
#ifndef TARGET_IPHONE_SIMULATOR
	[attributes release];
#endif
	return (result == noErr);
}

- (BOOL)deleteFromKeychain {
	NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
	[queryParams setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[queryParams setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

	OSStatus result = SecItemDelete((CFDictionaryRef)queryParams);
	return result == noErr;
}

- (BOOL)addToKeychain {
	NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
	[queryParams setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[queryParams setObject:base forKey:(id)kSecAttrService];
	if (username) {
		[queryParams setObject:username forKey:(id)kSecAttrAccount];
	}
	if (password) {
		[queryParams setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
	}

	OSStatus result = SecItemAdd((CFDictionaryRef)queryParams, nil);
	return result == noErr;
}
	
- (void)save {
	if ([self keychainEntryExists]) {
		[self deleteFromKeychain];
	}
	[self addToKeychain];
}

#pragma mark -
#pragma mark NSCoder methods
#pragma mark -
- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:username forKey:@"username"];
	[coder encodeObject:password forKey:@"password"];
	[coder encodeObject:base forKey:@"baseHref"];
	[coder encodeObject:siteName forKey:@"title"];
}

- (id)initWithCoder:(NSCoder *)coder {
	username = [[coder decodeObjectForKey:@"username"] retain];
	password = [[coder decodeObjectForKey:@"password"] retain];
	base = [[coder decodeObjectForKey:@"baseHref"] retain];
	siteName = [[coder decodeObjectForKey:@"title"] retain];
	return self;
}

#pragma mark -
#pragma mark Equality
#pragma mark -

- (BOOL)isEqual:(id)anObject {
	if ([anObject class] != [UserInfo class]) {
		return NO;
	}
	return	[username isEqualToString:[anObject username]] &&
			[password isEqualToString:[anObject password]] &&
			[siteName isEqualToString:[anObject siteName]] &&
			[base isEqualToString:[anObject base]];
}

- (NSUInteger)hash {
	return [username hash] + [password hash] + [siteName hash] + [base hash];
}

@end
