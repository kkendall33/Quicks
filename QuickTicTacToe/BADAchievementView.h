//
//  BADAchievementView.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 2/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADAchievementView : UIView

-(void)setAppear;
-(void)setDissappear;
@property (weak, nonatomic) IBOutlet UIView *flash;
@property (weak, nonatomic) NSTimer *timer;
@property BOOL blink;
@property BOOL canBlink;
@property (weak, nonatomic) IBOutlet UILabel *achievementLbl;

@end
