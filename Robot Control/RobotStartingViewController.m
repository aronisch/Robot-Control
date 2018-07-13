//
//  ViewController.m
//  Robot Control
//
//  Created by Arthur Rönisch on 25/11/2014.
//  Copyright (c) 2014 Arthur Rönisch. All rights reserved.
//

#import "RobotStartingViewController.h"
#import "RobotDrivingViewController.h"

@interface RobotStartingViewController ()

@end

@implementation RobotStartingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(480, 460);
    self.scrollView.scrollEnabled = false;
    self.addrIPField.delegate = self;
    self.IPCamera.delegate = self;
    activeField.delegate = self;
    
    
    /*self.addrIPField.alpha = 0;
    self.IPCamera.alpha = 0;
    self.startButton.alpha = 0;
    self.blankRect.alpha = 0;
    self.blankRect2.alpha = 0;*/
    /*self.blankRect.transform = CGAffineTransformMakeTranslation(0, 160);
    self.blankRect2.transform = CGAffineTransformMakeTranslation(0, 160);
    self.startButton.transform = CGAffineTransformMakeTranslation(0, 160);
    self.IPCamera.transform = CGAffineTransformMakeTranslation(0, 160);
    self.addrIPField.transform = CGAffineTransformMakeTranslation(0, 160);*/
    self.fadingView.alpha = 0;
    self.fadingView.transform = CGAffineTransformMakeTranslation(0, 160);
    self.logoView.frame = CGRectMake(28, 106, 424, 106);
    [UIView animateWithDuration:1
                          delay:0.5
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^(void){
                         self.fadingView.alpha = 1;
                         //self.logoView.center = CGPointMake(28, 25);
                         self.logoView.frame = CGRectMake(28, 25, 424, 106);
                         
                         self.fadingView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scroll : x :%f y : %f",scrollView.contentOffset.x, scrollView.contentOffset.y);
}

- (IBAction)touchOutside:(UITextField *)sender {
    [sender resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)editingBegin:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
}
- (IBAction)editingEnd:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (IBAction)resignKeyboard:(UITextField *)sender
{
    [self.IPCamera becomeFirstResponder];
}
- (IBAction)resignKeyboardEnd:(UITextField *)sender
{
    [sender resignFirstResponder];
    if ([self allowingStart])
    {
        [self performSegueWithIdentifier:@"driving" sender:self];
    }
}

- (BOOL)allowingStart
{
    NSString *addrIP = self.addrIPField.text;
    int countPoint = 0;
    for (int i=0; i < [addrIP length]; i++)
    {
        if ([addrIP characterAtIndex:i] == '.')
        {
            countPoint++;
        }
    }
    int countIPValue = 0;
    if (countPoint == 3)
    {
        NSArray *IPCheck = [addrIP componentsSeparatedByString:@"."];
        for (NSString *nb in IPCheck)
        {
            if ([nb intValue]>=0 && [nb intValue] < 256 && ![nb isEqualToString:@""])
            {
                countIPValue++;
            }
        }
    }
    if ([addrIP length] == 0 || countIPValue != 4)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"Adresse IP Invalide" message:@"Veuillez rentrer une adresse IP valide : xxx.xxx.xxx.xxx" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        return false;
    }
    
    NSString *addrIPCamera = self.IPCamera.text;
    countPoint = 0;
    for (int i=0; i < [addrIPCamera length]; i++)
    {
        if ([addrIPCamera characterAtIndex:i] == '.')
        {
            countPoint++;
        }
    }
    countIPValue = 0;
    if (countPoint == 3)
    {
        NSArray *IPCheck = [addrIPCamera componentsSeparatedByString:@"."];
        for (NSString *nb in IPCheck)
        {
            if ([nb intValue]>=0 && [nb intValue] < 256 && ![nb isEqualToString:@""])
            {
                countIPValue++;
            }
        }
    }
    if ([addrIPCamera length] == 0 || countIPValue != 4)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"Adresse IP Caméra Invalide" message:@"Veuillez rentrer une adresse IP valide : xxx.xxx.xxx.xxx" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        return false;
    }
    /*if ([self.portField.text isEqualToString:@""])
     {
     [self performSegueWithIdentifier:@"driving" sender:self];
     return;
     }
     int port = [self.portField.text intValue];
     if (port <= 0 || port > 65535)
     {
     alert = [[UIAlertView alloc] initWithTitle:@"Port invalide" message:@"Veuillez rentrer un port entre 1 et 65535 ou aucun port" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
     [alert addButtonWithTitle:@"OK"];
     [alert show];
     return;
     }*/
    return true;
}

- (IBAction)start:(id)sender
{
    if ([self allowingStart])
    {
    [self performSegueWithIdentifier:@"driving" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"driving"]) {
        RobotDrivingViewController *drivingController = [segue destinationViewController];
        drivingController.addressIPCamera = self.IPCamera.text;
        drivingController.addressIP = self.addrIPField.text;
    }
}

@end
