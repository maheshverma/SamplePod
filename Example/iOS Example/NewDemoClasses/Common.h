//
//  Common.h
//  M2Screens
//
//  Created by Padmanabh on 15/10/15.
//  Copyright © 2015 Srikanth. All rights reserved.
//

#ifndef Common_h
#define Common_h

//#import "LSModel.h"
//#import "UIFont+CustomFont.h"
//#import "UIColor+HexColor.h"
//#import "UIView+BlurImage.h"
//#import "LSAppAnalytics.h"
//#import "BusinessInterface.h"
//#import "ObjectFactory.h"

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#define kAccessTokenKey @"access_token"
#define kWebViewControllerID @"WEB_VIEW_CONTROLLER"
#define kEnvironmentSelectionID @"ENVIRONMENT_SELECTION"
#define kRequestVerificationToken @"RequestVerificationToken"

#define kHTTPGETMethod @"GET"
#define kHTTPPOSTMethod @"POST"
#define kAuthorizationKey @"Authorization"

// Response Keys
#define kGetSessionDetailsResponse @"GetSessionDetailsResponse"
#define kGetSessionDetailsResult @"GetSessionDetailsResult"
#define kUserInfo @"UserInfo"
#define kUserId @"UserID"
#define kPanelPinDetails @"GetUserDetailsExResponse"
#define kDeviceAuthorizationAttributes @"DeviceAuthorizationAttributes"
#define kDeviceAttribute @"DeviceAttribute"
#define kPanelUserCode @"PanelUserCode"

#define kLocations @"Locations"
#define kLocationInfoBasic @"LocationInfoBasic"
#define kLocationID @"LocationID"
#define kDeviceList @"DeviceList"
#define kDeviceInfoBasic @"DeviceInfoBasic"
#define kDeviceID @"DeviceID"
#define kArmSecuritySystemResponse @"ArmSecuritySystemResponse"
#define kArmSecuritySystemResult @"ArmSecuritySystemResult"
#define kResultCode @"ResultCode"
#define kResultData @"ResultData"
#define kControlASwitchResponse @"ControlASwitchResponse"
#define kControlASwitchResult @"ControlASwitchResult"

// Environments Keys
#define kProdEnvironmentKey @"prod"
#define kDevEnvironmentKey @"dev"


#define kEnvironmentCellID @"EnvironmentCell"
#define kLoadingIndicatorTag 777

// URL'S
#define kLoginURL @"https://h-api-test.apigee.net/oauth2/app/login?apikey=hQ2AJDVXZrjWL6pYUAaYIznEZle0T9vb&redirect_uri=https%3A%2F%2Fh-api-test.apigee.net%2Fweb%2Fcallback&scope=security&app=Joe%20Test%20App&state=123"//@"https://h-api-test.apigee.net/web"
#define kBaseURL @"https://h-api-test.apigee.net/security"
#define kSessionDetailsAPIPath @"/sessiondetails"
#define kPINFetchAPIPath @"/pin"
#define kFetchStatus(iLocationID) [NSString stringWithFormat:@"/locations/%@/status", iLocationID]
#define kDisarmAPIPath(iLocationID, iPanelID) [NSString stringWithFormat:@"/locations/%@/panel/%@/disarm", iLocationID, iPanelID]
#define kDeviceArmAPIPath(iLocationID, iPanelID) [NSString stringWithFormat:@"/locations/%@/panel/%@/arm", iLocationID, iPanelID]
#define kSwitchAPIPath(iLocationID) [NSString stringWithFormat:@"/locations/%@/switch", iLocationID]
#define kFetchLocalURL @"/geolocation"

// Global Constants
#define kSecurityFunctionComponentHeight 280.0
#define kNavigationBarHeight 64.0
#define kFirstCellHeight 150

// Interface Keys
#define kSubscriptionFrameWorkInterface @"SubscriptionFrameWorkInterface"
#define kBusinessLogicInterface @"BusinessLogicInterface"
#define kNetworkLayerInterface @"NetworkLayerInterface"
#define kDataInterface @"DataInterface"

// Enums
typedef NS_ENUM(NSInteger, SecurityOperationType) {
	NoOperationType = 0,
	PanicSecurityOperationType,
	ArmSecurityOperationType,
	DisArmSecurityOperationType,
	ArmStaySecurityOperationType,
	ArmCustomSecurityOperationType,
	SessionDetailsOperationType,
	SystemStatusOperationType,
	GeolocationChangeOperationType
};

typedef NS_ENUM(NSInteger, PanelState) {
	PanelStateUnknown = -1,
	PanelStateReady = 0,
	PanelStateReadyWithIssues,
	PanelStateArmedAway,
	PanelStateArmedStay,
	PanelStateCustom,
	PanelStateArming,
	PanelStateDisarming,
	PanelStateAlarm,
	PanelStateArmedAwayByPass,
	PanelStateArmedStayByPass
};

#endif /* Common_h */
