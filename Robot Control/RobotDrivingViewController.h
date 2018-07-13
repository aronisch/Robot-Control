//
//  RobotDrivingViewController.h
//  Robot Control
//
//  Created by Arthur Rönisch on 25/11/2014.
//  Copyright (c) 2014 Arthur Rönisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "JoyStickView.h"
#import "SocketIO.h"

@interface RobotDrivingViewController : UIViewController <UIAlertViewDelegate, NSURLConnectionDelegate, UIWebViewDelegate, SocketIODelegate> {
    UIAlertView *alert;
    SocketIO *sockets;
    BOOL stateLEDs;
}

@property (strong, nonatomic)NSString *addressIP;
@property (strong, nonatomic)NSString *addressIPCamera;
@property (weak, nonatomic) IBOutlet UIWebView *cameraView;
@property (weak, nonatomic) IBOutlet JoyStickView *joystickMotor;
@property (weak, nonatomic) IBOutlet JoyStickView *joystickCamera;
//@property (strong, nonatomic) NSMutableDictionary *coordPolaire;
//@property (strong, nonatomic) NSMutableDictionary *coordXY;

//- (void)sendMotorData;

@end
