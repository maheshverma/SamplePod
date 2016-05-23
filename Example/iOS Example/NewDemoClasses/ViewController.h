//
//  ViewController.h
//  SignalRiPhoneDemo
//
//  Created by Gaurav Sharma on 1/12/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignalR.h"
@interface ViewController : UIViewController<SRConnectionDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;

@end

