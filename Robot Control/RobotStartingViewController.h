//
//  ViewController.h
//  Robot Control
//
//  Created by Arthur Rönisch on 25/11/2014.
//  Copyright (c) 2014 Arthur Rönisch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotStartingViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    UIAlertView *alert;
    UITextField *activeField;
}

@property (weak, nonatomic) IBOutlet UIView *fadingView;
@property (weak, nonatomic) IBOutlet UIImageView *blankRect2;
@property (weak, nonatomic) IBOutlet UIImageView *blankRect;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *addrIPField;
@property (weak, nonatomic) IBOutlet UITextField *IPCamera;
@end

