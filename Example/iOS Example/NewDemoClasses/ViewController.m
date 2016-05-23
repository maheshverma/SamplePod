             //
//  ViewController.m
//  SignalRiPhoneDemo
//
//  Created by Gaurav Sharma on 1/12/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"

#define kRequestVerificationToken @"RequestVerificationToken"

@interface ViewController ()
{
    
    NSString *aTokenString;
    NSString *sessionID;
    NSString *connectionIdReceived;
}
@property (weak, nonatomic) IBOutlet UILabel *txtHitCount;
@end
SRHubProxy *proxyHub;
SRHubConnection *hubConnection;

typedef void(^sessionDataCompletion)(BOOL);
typedef void(^postLiveFeedCompletion)(BOOL);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the wview, typically from a nib.
    [self getSessionDetails:^(BOOL finished) {
        if(finished) {
            
            NSLog(@"Mt Token String=%@",aTokenString);
            NSString *cookieString=[NSString stringWithFormat:@"___CHAPI_SESSION_ID___=%@",sessionID];
            NSDictionary *headerParams=@{@"RequestVerificationToken":aTokenString,@"Cookie":cookieString};
            NSMutableDictionary *iHeaderDict=[NSMutableDictionary dictionaryWithDictionary:headerParams];
            [hubConnection setHeaders:iHeaderDict];
            
            NSString *server=@"http://lyricsecuritysignalrserverhubqa.cloudapp.net/signalr/hubs";
           // hubConnection = [SRHubConnection connectionWithURL:server];
            hubConnection=[SRHubConnection connectionWithURLString:server];
            proxyHub = [hubConnection createHubProxy:@"CHILServerHub"];
            hubConnection.delegate=self;
            [hubConnection start];
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSessionDetails :(sessionDataCompletion) sessionDataReceived {
    NetworkManager *aNetworkObject=[NetworkManager sharedManager];
    [aNetworkObject setHTTPBaseURLString:@"http://lyricsecuritychilqa.cloudapp.net/"];
    [aNetworkObject fetchDataForPOSTRequestString:@"api/session/" parameterData:@{@"username" : @"securityappet2@honeywell.com", @"password" : @"Password1", @"language" : @"en-US"} withCompletionBlock:^(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (isRequestSuccessfull) {
                NSDictionary *aResultDictionary = iResult;
                
                if (aResultDictionary[@"bodytoken"] && iResponse.allHeaderFields[kRequestVerificationToken]) {
                    aTokenString = [NSString stringWithFormat:@"%@:%@", iResponse.allHeaderFields[kRequestVerificationToken], aResultDictionary[@"bodytoken"]];
                    sessionID=aResultDictionary[@"sessionID"];
                    [aNetworkObject configureHTTPHeaderData:@{kRequestVerificationToken : aTokenString}];
                    sessionDataReceived(YES);
                } else {
                    
                    NSLog(@"Body token or Session ID is missing");
                }
            } else if (iError) {
                NSLog(@"Error ioccured");
                
            }
        });
    }];
}
-(void)postLiveFeedEvents :(postLiveFeedCompletion) liveFeedEventsSent {
    
    NetworkManager *aNetworkObject=[NetworkManager sharedManager];
    [aNetworkObject setHTTPBaseURLString:@"http://lyricsecuritychilqa.cloudapp.net/"];
    [aNetworkObject fetchDataForPOSTRequestString:@"api/SignalRLiveFeedEvents" parameterData:@{@"SignalRConnectionID":connectionIdReceived} withCompletionBlock:^(NSHTTPURLResponse *iResponse, BOOL isRequestSuccessfull, id iResult, NSError *iError) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (isRequestSuccessfull) {
                NSDictionary *aResultDictionary = iResult;
                liveFeedEventsSent(YES);
                /*   if (aResultDictionary[@"bodytoken"] && iResponse.allHeaderFields[kRequestVerificationToken]) {
                 aTokenString = [NSString stringWithFormat:@"%@:%@", iResponse.allHeaderFields[kRequestVerificationToken], aResultDictionary[@"bodytoken"]];
                 sessionID=aResultDictionary[@"sessionID"];
                 liveFeedEventsSent(YES);
                 } else {
                 
                 NSLog(@"Body token or Session ID is missing");
                 }
                 } else if (iError) {
                 NSLog(@"Error ioccured");*/
                
            }
        });
    }];
    
}
#pragma mark -
#pragma mark SRConnection Delegate

- (void)SRConnectionDidOpen:(SRConnection *)connection {
    NSLog(@"Connection Opened");
    connectionIdReceived=connection.connectionId;
    [self postLiveFeedEvents:^(BOOL finished) {
        
        [proxyHub on:@"sendLiveFeedMessage" perform:self selector:@selector(dataReceivedFromSignalR:)];
        [proxyHub invoke:@"pingServerHub" withArgs:@[] completionHandler: ^(id response,NSError *error){
            if(response){
                
            }
        }];
        
    }];
}

-(void)SRConnection:(SRConnection *)connection didReceiveData:(id)data {
    if (data != nil) {
        
        NSLog(@"Data: %@",data);
        
//        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        if([data isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"Data Received=%@",newStr);
//            
//
//            [self.responseTextView setText:newStr];
//            
//        } else {
//            NSLog(@"Data Received=%@",newStr);
//             [self.responseTextView setText:newStr];
//        }
    }
}

- (void)SRConnectionDidClose:(SRConnection *)connection {
    NSLog(@"Connection Closed");
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error {
    NSLog(@"Error Recieved=%@",[error description]);
    
}

-(void)dataReceivedFromSignalR:(NSString *)id {
    NSLog(@"data received=%@",id);
}
@end
