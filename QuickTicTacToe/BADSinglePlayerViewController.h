//
//  BADSinglePlayerViewController.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADGameState.h"
#import "BADSetupSingle.h"
#import <QuartzCore/CoreAnimation.h>
#import "DazFireworksController.h"
#import <iAd/ADBannerView.h>
#import "GAI.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BADAppDelegate.h"

typedef enum {
    TTGameNotOver = 0,
    TTGameOverxWins = 1,
    TTGameOveroWins = 2,
    TTGameOverTie = 3,
    TTGameOverxWinsTime = 4,
    TTGameOveroWinsTime = 5
}TTGameOverStatus;

typedef enum
{
    TTTimerOn = 0,
    TTTimerOff = 1
}TTTimerStatus;

typedef enum
{
    TTGameEasy = 0,
    TTGameHard = 1
}TTGameDifficulty;

@interface BADSinglePlayerViewController : GAITrackedViewController<UIAlertViewDelegate, ADBannerViewDelegate>
{
    NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
    NSDate *startDate; // Stores the date of the click on the start button
    double decisecondX;
    double decisecondO;
    TTTimerStatus timerStatus;
    BOOL firstPlayer;
    NSString *difficulty;
    BOOL trappedSide;
}

@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (weak, nonatomic) ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *spaceButton;
@property (weak, nonatomic) IBOutlet UILabel *timerO;
@property (weak, nonatomic) IBOutlet UILabel *timerX;
@property (strong, nonatomic) UIImage * xImage;
@property (strong, nonatomic) UIImage * oImage;
@property (strong, nonatomic) BADGameState *theGameState;
@property (strong, nonatomic) NSString *xPlayerName;
@property (strong, nonatomic) NSString *oPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *oPlayerLbl;
@property (weak, nonatomic) IBOutlet UILabel *xPlayerLbl;
@property (weak, nonatomic) IBOutlet UIButton *myBrandNewGame;
@property (weak, nonatomic) IBOutlet UIButton *turnXBtn;
@property (weak, nonatomic) IBOutlet UIButton *turnOBtn;
@property (strong, nonatomic) BADSetupSingle *setup;
@property CGFloat birthRate;
@property CAEmitterLayer *fireworksEmitter;
//@property DazFireworksController *fireWorks;
@property BOOL animation;
@property BOOL setupShowing;
@property (nonatomic, strong) BADAppDelegate *app;

// UI Methods
- (IBAction)spaceButtonTapped:(id)sender;
- (IBAction)newGameTUI:(id)sender;
- (IBAction)turnOTUI;
- (IBAction)turnXTUI;
- (IBAction)backBtnTUI:(id)sender;

// Gameplay Methods
-(void) initGame;
-(void) updateBoard;
-(void) updateGameStatus;
-(TTGameOverStatus) checkGameOver;
-(BOOL) didPlayerWin:(NSString *)player;
-(void)endGameWithResult:(TTGameOverStatus)result;

@end
