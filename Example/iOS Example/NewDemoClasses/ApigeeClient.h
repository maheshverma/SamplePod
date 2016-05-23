//
//  ApigeeClient.h
//  Arm
//
//  Created by Padmanabh on 6/17/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApigeeClient : NSObject

- (instancetype)initWithBaseURLString:(NSString *)iBaseURLString;

- (void)fetchDataForGETRequestString:(NSString *)iRequestString forHeaderData:(NSDictionary *)iHeaderData parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void(^)(NSHTTPURLResponse *iResponse ,BOOL isRequestSuccessfull, id iResult, NSError *iError))iCompletionBlock;

- (void)fetchDataForPOSTRequestString:(NSString *)iRequestString forHeaderData:(NSDictionary *)iHeaderData parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void(^)(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError))iCompletionBlock;

@end
