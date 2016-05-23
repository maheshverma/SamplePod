//
//  ApigeeClient.m
//  Arm
//
//  Created by Padmanabh on 6/17/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "ApigeeClient.h"
#import "Common.h"

@interface ApigeeClient ()

@property(nonatomic, strong) NSURL *baseURL;

@end

@implementation ApigeeClient

- (instancetype)initWithBaseURLString:(NSString *)iBaseURLString {
	if (self = [super init]) {
		self.baseURL = [NSURL URLWithString:iBaseURLString];
	}
	
	return self;
}


- (instancetype)init {
	if (self = [super init]) {
		self.baseURL = [NSURL URLWithString:kBaseURL];
	}
	
	return self;
}


- (void)setCustomBaseURL:(NSString *)iCustomBaseURL {
	self.baseURL = [NSURL URLWithString:iCustomBaseURL];
}


- (void)fetchDataForGETRequestString:(NSString *)iRequestString forHeaderData:(NSDictionary *)iHeaderData parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void (^)(NSHTTPURLResponse *, BOOL, id, NSError *))iCompletionBlock {
	NSURLRequest *anURLRequest = [self createURLRequestForGETRequestString:iRequestString WithHeaderFields:iHeaderData withParameterData:iParameterData];
	[self makeServerCallForRequest:anURLRequest withCompletionBlock:iCompletionBlock];
}


- (void)fetchDataForPOSTRequestString:(NSString *)iRequestString forHeaderData:(NSDictionary *)iHeaderData parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void (^)(NSHTTPURLResponse *, BOOL, id, NSError *))iCompletionBlock {
	NSURLRequest *anURLRequest = [self createURLRequestForPOSTRequestString:iRequestString WithHeaderFields:iHeaderData withParameterData:iParameterData];
	[self addPOSTBodyToRequest:anURLRequest WithParameterData:iParameterData];
	
	[self makeServerCallForRequest:anURLRequest withCompletionBlock:iCompletionBlock];
}


- (void)makeServerCallForRequest:(NSURLRequest *)iRequest withCompletionBlock:(void (^)(NSHTTPURLResponse *, BOOL, id, NSError *))iCompletionBlock {
	NSURLSessionConfiguration *aSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *anURLSession = [NSURLSession sessionWithConfiguration:aSessionConfiguration];
	
	NSURLSessionDataTask *aSessionDataTask = [anURLSession dataTaskWithRequest:iRequest completionHandler:^ (NSData *iData, NSURLResponse *iResponse, NSError *iError) {
		NSHTTPURLResponse *anHTTPURLResponse = (NSHTTPURLResponse *)iResponse;
		
		if (anHTTPURLResponse.statusCode >= 200 && anHTTPURLResponse.statusCode < 300 && iError == nil) {
			NSError *anError;
			id aPrasedResult = [NSJSONSerialization JSONObjectWithData:iData options:NSJSONReadingAllowFragments error:&anError];
			
			if (!anError) {
				iCompletionBlock(anHTTPURLResponse, YES, aPrasedResult, nil);
			} else {
				iCompletionBlock(anHTTPURLResponse, NO, nil, iError);
			}
		} else if (anHTTPURLResponse.statusCode == 401) {
			// TODO: Reauthenticate User
			NSError *anError = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Re Authentication is required"}];
			iCompletionBlock(anHTTPURLResponse, NO, nil, anError);
		} else if (anHTTPURLResponse.statusCode == 400) {
			NSError *anError;
			
			if (iData) {
				id aPrasedResult = [NSJSONSerialization JSONObjectWithData:iData options:NSJSONReadingAllowFragments error:nil];
				
				if ([aPrasedResult isKindOfClass:[NSDictionary class]] && aPrasedResult[@"ResultData"]) {
					anError = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : aPrasedResult[@"ResultDatas"]}];
				} else if ([aPrasedResult isKindOfClass:[NSDictionary class]] && aPrasedResult[@"message"]) {
					anError = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : aPrasedResult[@"message"]}];
				}
			}
			
			iCompletionBlock(anHTTPURLResponse, NO, nil, anError);
		} else if (iError) {
			iCompletionBlock(anHTTPURLResponse, NO, nil, iError);
		} else {
			id aPrasedResult;
			
			if (iData) {
				NSError *anError;
				aPrasedResult = [NSJSONSerialization JSONObjectWithData:iData options:NSJSONReadingAllowFragments error:&anError];
			}
			
			iCompletionBlock(anHTTPURLResponse, NO, aPrasedResult, nil);
		}
	}];
	
	[aSessionDataTask resume];
}


- (void)addPOSTBodyToRequest:(NSURLRequest *)iRequest WithParameterData:(NSDictionary *)iParameterData {
	if (iParameterData) {
		NSMutableURLRequest *aMutableRequest = (NSMutableURLRequest *)iRequest;
		[aMutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:iParameterData options:0 error:nil]];
	}
}


- (NSURLRequest *)createURLRequestForGETRequestString:(NSString *)iRequestString WithHeaderFields:(NSDictionary *)iHeaderData withParameterData:(NSDictionary *)iParameterData {
	return [self createURLRequestForRequestString:iRequestString HTTPMethod:kHTTPGETMethod withHeaderData:iHeaderData withParameterData:iParameterData];
}


- (NSURLRequest *)createURLRequestForPOSTRequestString:(NSString *)iRequestString WithHeaderFields:(NSDictionary *)iHeaderData withParameterData:(NSDictionary *)iParameterData {
	return [self createURLRequestForRequestString:iRequestString HTTPMethod:kHTTPPOSTMethod withHeaderData:iHeaderData withParameterData:iParameterData];
}


- (NSURLRequest *)createURLRequestForRequestString:(NSString *)iRequestString HTTPMethod:(NSString *)iHTTPMethod withHeaderData:(NSDictionary *)iHeaderData withParameterData:(NSDictionary *)iParameterData {
	NSURL *anURL = [NSURL URLWithString:iRequestString relativeToURL:self.baseURL];
	NSMutableURLRequest *anURLRequest = [[NSMutableURLRequest alloc] initWithURL:anURL];
	[anURLRequest setHTTPMethod:iHTTPMethod];
    
    if(iHeaderData != nil)
        anURLRequest.allHTTPHeaderFields = iHeaderData;
    
	return anURLRequest;
}

@end
