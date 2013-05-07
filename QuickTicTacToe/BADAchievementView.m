//
//  BADAchievementView.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 2/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADAchievementView.h"
#import "GAI.h"

@implementation BADAchievementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setAppear
{
    self.blink = YES;
    self.canBlink = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:8.0
                                     target:self
                                   selector:@selector(setDissappear)
                                   userInfo:nil
                                    repeats:NO];
    
    CGRect f = self.frame;
    f.origin.y += f.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:f];
    }];
    [self toggleFlash];
}

-(void)setDissappear
{
    self.canBlink = NO;
    [self.timer invalidate];
    self.timer = NULL;
    CGRect f = self.frame;
    f.origin.y = -35;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = f;
    }];
}

-(void)toggleFlash
{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.6
                                                      target:self
                                                    selector:@selector(flashBlink:)
                                                    userInfo:[NSNumber numberWithBool:self.blink]
                                                     repeats:YES];
}

-(void)flashBlink:(NSTimer *)blink
{
    if(self.blink)
    {
        CGRect f = self.frame;
        [UIView transitionWithView:self
                          duration:.3
                           options: (UIViewAnimationOptionCurveEaseOut)
                        animations:^{
                            self.frame = self.frame = CGRectMake(self.center.x - 60, self.center.y - 12.5, 120, 25);
                            [self.flash setAlpha:0];
                        }
                        completion:^(BOOL finished){
                            [self resizeView:f];
                        }
         ];
        self.blink = !self.blink;
    }
    else
    {
        CGRect f = self.frame;
        [UIView transitionWithView:self
                          duration:.3
                           options: (UIViewAnimationOptionCurveEaseOut)
                        animations:^{
                            self.frame = self.frame = CGRectMake(self.center.x - 75, self.center.y - 17.5, 150, 35);
                            [self.flash setAlpha:1];
                        }
                        completion:^(BOOL finished){
                            [self resizeView:f];
                        }
         ];
        self.blink = !self.blink;
    }
}

-(void)resizeView:(CGRect)f
{
    if(self.canBlink)
    {
        [UIView transitionWithView:self
                          duration:.3
                           options: (UIViewAnimationOptionCurveEaseIn)
                        animations:^{
                            self.frame = f;
                        }
                        completion:^(BOOL finished){
                            
                        }
         ];
    }
}

@end
