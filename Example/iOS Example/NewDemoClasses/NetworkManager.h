//
//  NetworkManager.h
//  M2Screens
//
//  Created by Padmanabh on 04/11/15.
//  Copyright © 2015 Srikanth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "NetworkInterface.h"

typedef NS_ENUM(NSInteger, WebSocketType) {
	AppGatewayWebSocketType   = 0,
	AppCloudWebSocketType
};

@interface NetworkManager : NSObject <NetworkInterface>

+ (NetworkManager *)sharedManager;

- (void)openWebSocketOfType:(WebSocketType)iWebSocketType forIP:(NSString *)iIP forPort:(NSString *)iPort;

- (void)closeWebSocketOfType:(WebSocketType)iWebSocketType;

@end
