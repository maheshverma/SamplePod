//
//  NetworkManager.m
//  M2Screens
//
//  Created by Padmanabh on 04/11/15.
//  Copyright © 2015 Srikanth. All rights reserved.
//

#import "NetworkManager.h"
#import "SRWebSocket.h"
//#import "ObjectFactory.h"
//#import "BusinessInterface.h"
#import "ApigeeClient.h"

@interface NetworkManager ()

@property(nonatomic, strong) NSMutableArray *webSocketPool;

@property(nonatomic, strong) NSMutableDictionary *httpHeaderData;

@property(nonatomic, strong) NSString *baseURLString;

@end

@implementation NetworkManager

+ (instancetype)sharedManager {
	static dispatch_once_t pred;
	static NetworkManager *shared = nil;
	
	dispatch_once(&pred, ^{
		shared = [[NetworkManager alloc] init];
	});
	
	return shared;
}


- (instancetype)init {
	if (self = [super init]) {
		self.webSocketPool = [NSMutableArray array];
		self.httpHeaderData = [NSMutableDictionary dictionaryWithDictionary:@{@"Accept" : @"application/json", @"Accept-Language" : @"en-US;q=1", @"User-Agent" : @"Lyric/2.0 (iPhone; iOS 9.1; Scale/2.00)"}];
	}
	
	return self;
}


#pragma mark - HTTP GET/POST API's

- (void)fetchDataForGETRequestString:(NSString *)iRequestString parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void (^)(NSHTTPURLResponse *, BOOL, id, NSError *))iCompletionBlock {
	ApigeeClient *anApigeeClient = [[ApigeeClient alloc] initWithBaseURLString:self.baseURLString];
	
	[anApigeeClient fetchDataForGETRequestString:iRequestString forHeaderData:self.httpHeaderData parameterData:iParameterData withCompletionBlock:^(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError) {
		iCompletionBlock(iResponse, isRequestSuccessfull, iResult, iError);
	}];
}


- (void)fetchDataForPOSTRequestString:(NSString *)iRequestString parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void (^)(NSHTTPURLResponse *, BOOL, id, NSError *))iCompletionBlock {
	ApigeeClient *anApigeeClient = [[ApigeeClient alloc] initWithBaseURLString:self.baseURLString];
	
	NSMutableDictionary *aHTTPHeaderData = self.httpHeaderData;
	aHTTPHeaderData[@"Content-Type"] = @"application/json";
	
	[anApigeeClient fetchDataForPOSTRequestString:iRequestString forHeaderData:aHTTPHeaderData parameterData:iParameterData withCompletionBlock:^(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError) {
		iCompletionBlock(iResponse, isRequestSuccessfull, iResult, iError);
	}];
}


#pragma mark - Public API's

- (void)setHTTPBaseURLString:(NSString *)iBaseURLString {
	self.baseURLString = iBaseURLString;
}


- (void)configureHTTPHeaderData:(NSDictionary *)iHeaderData {
	[self.httpHeaderData addEntriesFromDictionary:iHeaderData];
}


//- (void)openWebSocketOfType:(WebSocketType)iWebSocketType forIP:(NSString *)iIP forPort:(NSString *)iPort {
//	BOOL doesWebSocketAlreadyExists = NO;
//	
//	for (SRWebSocket *aWebSocket in self.webSocketPool) {
//		if (aWebSocket.webSocketType == iWebSocketType) {
//			doesWebSocketAlreadyExists = YES;
//			
//			if (aWebSocket.readyState != SR_OPEN) {
//				[aWebSocket open];
//			}
//			
//			break;
//		}
//	}
//	
//	if (!doesWebSocketAlreadyExists) {
//		SRWebSocket *aWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self createWebSocketURLStringForIP:iIP forPort:iPort]]] protocols:nil allowsUntrustedSSLCertificates:YES];
//		aWebSocket.delegate = self;
//		[aWebSocket scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//		[aWebSocket open];
//		[self.webSocketPool addObject:aWebSocket];
//	}
//}
//
//
//- (void)closeWebSocketOfType:(WebSocketType)iWebSocketType {
//	for (SRWebSocket *aWebSocket in self.webSocketPool) {
//		if (aWebSocket.webSocketType == iWebSocketType) {
//			[aWebSocket close];
//			break;
//		}
//	}
//}
//
//
//#pragma mark - Private API's
//
//- (NSString *)createWebSocketURLStringForIP:(NSString *)iIP forPort:(NSString *)iPort {
//	return [NSString stringWithFormat:@"ws://%@:%@", iIP, iPort];
//}
//
/*
# pragma mark WebSocketDelegate Methods

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
	NSString *aString = message;
	NSData *aData = [aString dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *aDictionary = [NSJSONSerialization JSONObjectWithData:aData options:0 error:nil];
	
	id aBusinessManager = [[ObjectFactory sharedInstance] objectForInterface:kBusinessLogicInterface];
	[aBusinessManager webSocketResponseModel:aDictionary];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
	NSLog(@"webSocketDidOpen");
}


- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
	NSLog(@"didFailWithError");
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
	NSLog(@"didCloseWithCode: %ld reason: %@", (long)code, reason);
}


- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
	NSLog(@"didReceivePong");
}
*/
@end
