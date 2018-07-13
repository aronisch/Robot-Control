//
//  VisualStickView.m
//  SampleGame
//
//  Created by Zhang Xiang on 13-4-26.
//  Copyright (c) 2013年 Myst. All rights reserved.
//

#import "JoyStickView.h"

#define STICK_CENTER_TARGET_POS_LEN 40.0f

@implementation JoyStickView

-(void) initStick
{
    imgStickNormal = nil;//[UIImage imageNamed:@"stick_normal.png"];
    imgStickHold = [UIImage imageNamed:@"stick_hold.png"];
//    stickView.image = imgStickNormal;
    mCenter.x = 75;
    mCenter.y = 75;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initStick];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
	{
        // Initialization code
        [self initStick];
    }
	
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)notifyDir:(NSDictionary *)coord withJoystickName:(NSString *)joystickName//(CGPoint)dir
{
    
    //NSValue *vdir = [NSValue valueWithCGPoint:dir];
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:vdir, @"dir", nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:[NSString stringWithFormat:@"StickChanged%@",joystickName] object:nil userInfo:coord];
    
}

- (void)stickMoveTo:(CGPoint)deltaToCenter
{
    CGRect fr = stickView.frame;
    fr.origin.x = deltaToCenter.x;
    fr.origin.y = deltaToCenter.y;
    stickView.frame = fr;
}

- (void)touchEvent:(NSSet *)touches
{

    if([touches count] != 1)
        return ;
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self)
        return ;
    
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint dtarget, dir;
    dir.x = touchPoint.x - mCenter.x;
    dir.y = touchPoint.y - mCenter.y;

    
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);
    double length = len;
    double angle = 0.0;
    if(len < 5.0 /*&& len > -10.0*/)
    {
        // center pos
        dtarget.x = 0.0;
        dtarget.y = 0.0;
        dir.x = 0;
        dir.y = 0;
        angle = 0.0;
        length = 0.0;
    }
    else if(len > 40)
    {
        double len_inv = (1.0 / len);
        /*dir.x *= len_inv;
        dir.y *= len_inv;*/
        dtarget.x = dir.x * len_inv * STICK_CENTER_TARGET_POS_LEN;
        dtarget.y = dir.y * len_inv * STICK_CENTER_TARGET_POS_LEN;
        dir.x = dtarget.x;
        dir.y = dtarget.y;
        length = 40.0;
    }
    else
    {
        /*double len_inv = (1.0 / len);
        dir.x *= len_inv;
        dir.y *= len_inv;*/
        dtarget.x = dir.x; //* STICK_CENTER_TARGET_POS_LEN;
        dtarget.y = dir.y; //* STICK_CENTER_TARGET_POS_LEN;
        /*double len_inv = (1.0 / len);
        dir.x *= len_inv;
        dir.y *= len_inv;*/
    }
    [self stickMoveTo:dtarget];
    //Envoi de données selon Joystick
    double coordX = dir.x;
    double coordY = -dir.y;
    NSDictionary *coord;
    if ([self.name isEqualToString:@"Motor"])
    {
        if (coordX > 0 && coordY >= 0) {
            angle = atan(coordY / coordX);
        } else if (coordX > 0 && coordY < 0) {
            angle = atan(coordY / coordX) + 2 * M_PI;
        } else if (coordX < 0) {
            angle = atan(coordY / coordX) + M_PI;
        } else if (coordX == 0 && coordY > 0) {
            angle = M_PI / 2;
        } else if (coordX == 0 && coordY < 0) {
            angle = 3 * M_PI /2;
        }
        NSNumber *lengthValue = [NSNumber numberWithDouble:length];
        NSNumber *angleValue = [NSNumber numberWithDouble:angle];
        coord = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lengthValue, angleValue, nil] forKeys:[NSArray arrayWithObjects:@"length", @"angle", nil]];
    } else if ([self.name isEqualToString:@"Camera"])
    {
        NSNumber *coordXNumber = [NSNumber numberWithDouble:coordX];
        NSNumber *coordYNumber = [NSNumber numberWithDouble:coordY];
        coord = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:coordXNumber, coordYNumber, nil] forKeys:[NSArray arrayWithObjects:@"coordX", @"coordY", nil]];
    }
    [self notifyDir:coord withJoystickName:self.name];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [stickView setImage:imgStickHold];
    [self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEvent:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    stickView.image = imgStickNormal;
    CGPoint dtarget, dir;
    dir.x = dtarget.x = 0.0;
    dir.y = dtarget.y = 0.0;
    [self stickMoveTo:dtarget];
    NSDictionary *coord;
    
    if ([self.name isEqualToString:@"Motor"])
    {
        NSNumber *lengthValue = [NSNumber numberWithDouble:0.0];
        NSNumber *angleValue = [NSNumber numberWithDouble:0.0];
        coord = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lengthValue, angleValue, nil] forKeys:[NSArray arrayWithObjects:@"length", @"angle", nil]];
    } else if ([self.name isEqualToString:@"Camera"])
    {
        NSNumber *coordXNumber = [NSNumber numberWithInt:0];
        NSNumber *coordYNumber = [NSNumber numberWithInt:0];
        coord = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:coordXNumber, coordYNumber, nil] forKeys:[NSArray arrayWithObjects:@"coordX", @"coordY", nil]];
    }
    [self notifyDir:coord withJoystickName:self.name];
}

@end
