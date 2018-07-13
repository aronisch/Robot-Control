//
//  RobotDrivingViewController.m
//  Robot Control
//
//  Created by Arthur Rönisch on 25/11/2014.
//  Copyright (c) 2014 Arthur Rönisch. All rights reserved.
//

#import "RobotDrivingViewController.h"
#import "JoyStickView.h"

@interface RobotDrivingViewController ()

@end

@implementation RobotDrivingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *cameraUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", _addressIPCamera]];
    [self.cameraView.scrollView setScrollEnabled:NO];
    [self.cameraView loadRequest:[NSURLRequest requestWithURL:cameraUrl]];
    [self.cameraView setDelegate:self];
    self.joystickMotor.name = @"Motor";
    self.joystickCamera.name = @"Camera";
    /*NSMutableDictionary *coordPolaireInitiale = [NSMutableDictionary dictionaryWithObject:@"0" forKey:@"moteurright"];
    [coordPolaireInitiale setObject:@"0" forKey:@"moteurleft"];
    self.coordPolaire = coordPolaireInitiale;
    NSMutableDictionary *coordXYInitiale = [NSMutableDictionary dictionaryWithObject:@"0" forKey:@"coordX"];
    [coordXYInitiale setObject:@"0" forKey:@"coordY"];
    self.coordXY = coordXYInitiale;*/

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (onStickChangedMotor:)
                               name: @"StickChangedMotor"
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector (onStickChangedCamera:)
                               name: @"StickChangedCamera"
                             object: nil];
    
    NSLog(@"AddrCam : %@",self.addressIPCamera);
    
    stateLEDs = false;
    
    sockets = [[SocketIO alloc]initWithDelegate:self];
    [sockets connectToHost:self.addressIP onPort:80];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SocketIODelegate

- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected");
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
    /*[self.cameraView loadHTMLString:[NSString stringWithFormat:@"<!doctype html><html><head><meta charset='utf-8'><title></title><style>body { background-color:#555555;}</style><p>%@</p></body></html>", error.description] baseURL:nil];*/
    /*self.cameraView.tintColor = [UIColor darkGrayColor];
    self.cameraView.backgroundColor  = [UIColor darkGrayColor];*/
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    //[socket sendEvent:@"Date" withData:@"Date"];
    //[socket sendMessage:@"Date"];
}

#pragma UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //[webView loadHTMLString:[NSString stringWithFormat:@"%@", error.description] baseURL:nil];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma NSURLConnectionDelegate

/*- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    alert = [[UIAlertView alloc]initWithTitle:@"Erreur de Connexion" message:@"Impossible de se connecter veuillez vérifier votre connexion réseau" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}*/

- (IBAction)stopDriving:(id)sender
{
    self.addressIP = nil;
    self.addressIPCamera = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)changementPhares:(id)sender {
    stateLEDs = !stateLEDs;
    NSMutableDictionary *dicSend = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i",stateLEDs] forKey:@"LEDstate"];
    [sockets sendEvent:@"LEDs" withData:dicSend];
}

- (void)onStickChangedMotor:(id)notification
{
    NSDictionary *dict = [notification userInfo];
    NSNumber *length = [dict valueForKey:@"length"];
    NSNumber *angle = [dict valueForKey:@"angle"];
    //NSLog(@"Dir x: %f Dir y: %f", coordCartx, coordCarty);
    //NSLog(@"Coordonnées Polaire : Téta :%@ R :%@", angle, length);
    float moteurRightFactor;
    float moteurLeftFactor;
    double angleDouble = [angle doubleValue];
    double lengthDouble = [length doubleValue] / 8;
    if (lengthDouble != 0)
    {
        if (5*M_PI/12 <= angleDouble && 7*M_PI/12 > angleDouble) //joystick vers l'avant
        {
            moteurLeftFactor =  2.0;
            moteurRightFactor  = 2.0;
        }
        else if (3*M_PI/12 <= angleDouble && 5*M_PI/12 > angleDouble)
        {
            moteurRightFactor = 1.0;
            moteurLeftFactor = 2.0;
        }
        else if (1*M_PI/12 <= angleDouble && 3*M_PI/12 > angleDouble)
        {
            moteurRightFactor = 0.0;
            moteurLeftFactor = 2.0;
        }
        else if ((0 < angleDouble && 1*M_PI/12 > angleDouble) || (23*M_PI/12 <= angleDouble && 24*M_PI/12 > angleDouble) || angleDouble == 0.0)
        {
            moteurRightFactor = -2.0;
            moteurLeftFactor = 2.0;
        }
        else if (21*M_PI/12 <= angleDouble && 23*M_PI/12 > angleDouble)
        {
            moteurRightFactor = 0.0;
            moteurLeftFactor = -2.0;
        }
        else if (19*M_PI/12 <= angleDouble && 21*M_PI/12 > angleDouble)
        {
            moteurRightFactor = -1.0;
            moteurLeftFactor = -2.0;
        }
        else if (17*M_PI/12 <= angleDouble && 19*M_PI/12 > angleDouble)
        {
            moteurRightFactor = -2.0;
            moteurLeftFactor = -2.0;
        }
        else if (15*M_PI/12 <= angleDouble && 17*M_PI/12 > angleDouble)
        {
            moteurRightFactor = -2.0;
            moteurLeftFactor = -1.0;
        }
        else if (13*M_PI/12 <= angleDouble && 15*M_PI/12 > angleDouble)
        {
            moteurRightFactor = -2.0;
            moteurLeftFactor = 0.0;
        }
        else if (11*M_PI/12 <= angleDouble && 13*M_PI/12 > angleDouble)
        {
            moteurRightFactor = 2.0;
            moteurLeftFactor = -2.0;
        }
        else if (9*M_PI/12 <= angleDouble && 11*M_PI/12 > angleDouble)
        {
            moteurRightFactor = 2.0;
            moteurLeftFactor = 0.0;
        }
        else if (7*M_PI/12 <= angleDouble && 9*M_PI/12 > angleDouble)
        {
            moteurRightFactor = 2.0;
            moteurLeftFactor = 1.0;
        }
    }
    else
    {
        moteurRightFactor = 0.0;
        moteurLeftFactor = 0.0;
    }
    
    int moteurright = moteurRightFactor * lengthDouble;
    int moteurleft = moteurLeftFactor * lengthDouble;
    NSLog(@"MoteurRightFactor : %f MoteurLeftFactor : %f", moteurRightFactor, moteurLeftFactor);
    NSLog(@"moteur right: %d moteur left: %d", moteurright, moteurleft);
    NSMutableDictionary *dicSend = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",moteurright] forKey:@"speedRight"];
    [dicSend setObject:[NSString stringWithFormat:@"%d", moteurleft] forKey:@"speedLeft"];
    NSLog(@"Sending MotorRight : %d, MotorLeft : %d", moteurright, moteurleft);
    [sockets sendEvent:@"Moteur" withData:dicSend];
    
    /*self.coordPolaire = dicSend;
    [self sendMotorData];*/
    
}

- (void)onStickChangedCamera:(id) notification {
    NSDictionary *dict = [notification userInfo];
    NSNumber *coordX = [dict valueForKey:@"coordX"];
    NSNumber *coordY = [dict valueForKey:@"coordY"];
    int moteurX = [coordX intValue];
    int moteurY = [coordY intValue];
    NSMutableDictionary *coord = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",moteurX] forKey:@"ServoPositionX"];
    [coord setObject:[NSString stringWithFormat:@"%d", moteurY] forKey:@"ServoPositionY"];
    NSLog(@"Sending : ServoX : %d , ServoY: %d", moteurX, moteurY);
    [sockets sendEvent:@"Servo" withData:coord];
    
    /*self.coordXY = coord;
    [self sendMotorData];*/
}

/*- (void)sendMotorData
{
    NSString *moteurright = [self.coordPolaire objectForKey:@"moteurright"];
    NSString *moteurleft = [self.coordPolaire objectForKey:@"moteurleft"];
    NSString *moteurX = [self.coordXY objectForKey:@"coordX"];
    NSString *moteurY = [self.coordXY objectForKey:@"coordY"];
    NSLog(@"Sending MotorRight : %@, MotorLeft : %@, MotorX : %@, MotorY:%@", moteurright, moteurleft, moteurX, moteurY);
    
    //NSString *urlString = [NSString stringWithFormat:@"http://%@/update_state.php?moteurright=%@&moteurleft=%@&moteurCamX=%@&moteurCamY=%@", _addressIP, moteurright, moteurleft, moteurX, moteurY];
    
    //NSURL *url = [NSURL URLWithString:urlString];
    //NSLog(@"%@",urlString);
    
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod:@"GET"];
    //NSError *error = [[NSError alloc]init];
    //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    //if (!connection) {
    //    NSLog(@"Error connection");
    //    alert = [[UIAlertView alloc]initWithTitle:@"Erreur de Connexion" message:@"Impossible de créer la connexion réseau" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    //    [alert addButtonWithTitle:@"OK"];
    //    [alert show];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //}
    NSMutableDictionary *sendData = [NSMutableDictionary dictionaryWithObject:moteurright forKey:@"Moteurright"];
    [sendData setObject:moteurleft forKey:@"Moteurleft"];
    [sendData setObject:moteurX forKey:@"MoteurCamX"];
    [sendData setObject:moteurY forKey:@"MoteurCamY"];
    
    [sockets sendEvent:@"Moteur" withData:sendData];
    
}*/

@end
