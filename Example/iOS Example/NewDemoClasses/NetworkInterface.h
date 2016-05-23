//
//  NetworkInterface.h
//  Lyric Security
//
//  Created by Padmanabh on 06/10/15.
//  Copyright © 2015 Honeywell. All rights reserved.
//

@protocol NetworkInterface <NSObject>

- (void)setHTTPBaseURLString:(NSString *)iBaseURLString;

- (void)configureHTTPHeaderData:(NSDictionary *)iHeaderData;

- (void)fetchDataForGETRequestString:(NSString *)iRequestString parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void(^)(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError))iCompletionBlock;

- (void)fetchDataForPOSTRequestString:(NSString *)iRequestString parameterData:(NSDictionary *)iParameterData withCompletionBlock:(void(^)(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError))iCompletionBlock;

@end
