//
//  YOSBaseRequest.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSBaseRequest.h"

static NSString *const kRequestBaseUrl = @"http://social.yahooapis.com";
static NSString *const kRequestBaseVersion = @"v1";
static NSString *const kRequestBaseFormat = @"json";
static NSString *const kRequestBaseSignatureMethod = @"HMAC-SHA1";

@implementation YOSBaseRequest

@synthesize signatureMethod;
@synthesize baseUrl;
@synthesize format;
@synthesize apiVersion;
@synthesize user;
@synthesize consumer;
@synthesize token;

#pragma mark init

+ (id)requestWithSession:(YOSSession *)session
{
	YOSUser *user = [[YOSUser alloc] initWithSession:session];
	YOSBaseRequest *request = [[YOSBaseRequest alloc] initWithYOSUser:user];
	
	return request;
}

- (id)init
{
	if(self = [super init]) {
		[self setBaseUrl:kRequestBaseUrl];
		[self setFormat:kRequestBaseFormat];
		[self setApiVersion:kRequestBaseVersion];
		[self setSignatureMethod:kRequestBaseSignatureMethod];
	}
	return self;
}

- (id)initWithYOSUser:(YOSUser *)aSessionedUser
{
	if(self = [self init]) {
		[self setUser:aSessionedUser];
	}
	
	return self;
}

- (id)initWithConsumer:(YOAuthConsumer *)aConsumer
{
	if(self = [self init]) {
		[self setConsumer:aConsumer];
	}
	return self;
}

#pragma mark -
#pragma mark Protected

- (YOAuthConsumer *)oauthConsumer
{
	YOAuthConsumer *theConsumer = (user) ? [user.session consumer] : consumer;	
	return theConsumer;
}

- (YOAuthToken *)oauthToken
{
	YOAuthToken *theToken = (user) ? [user.session accessToken] : token;
	return theToken;
}

- (YOSRequestClient *)requestClient
{
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self oauthConsumer]
																 andToken:[self oauthToken]];
	
	return client;
}

- (id)deserializeJSON:(NSData *)value
{
	NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:value options:0 error:&error];
    if(error)
    {
        NSString *string = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
        NSLog(@"ERROR: deserializing value: %@, raason: %@", string, error);
    }
    return returnValue;
}

- (NSData *)serializeDictionary:(NSDictionary *)aDictionary
{
	// if you are using another JSON encoder/decoder, you can swap it out here.
    NSError *error = nil;
	NSData *returnValue = [NSJSONSerialization dataWithJSONObject:aDictionary options:0 error:&error];
    if(error)
    {
        NSLog(@"ERROR: Serializing Dictionary: %@, reason: %@", aDictionary, error);
    }
    return returnValue;
}

@end
