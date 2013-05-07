//
//  BADTwoPlayerViewController.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/22/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADGameState.h"
#import "GAITrackedViewController.h"
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

@interface BADTwoPlayerViewController : GAITrackedViewController<UIAlertViewDelegate>
{
    NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
    NSDate *startDate; // Stores the date of the click on the start button
    double decisecondX;
    double decisecondO;
    TTTimerStatus timerStatus;
    BOOL firstPlayer;
}

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
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
@property (strong, nonatomic) BADAppDelegate *app;

// UI Methods
- (IBAction)spaceButtonTapped:(id)sender;
- (IBAction)backBtnTUI:(id)sender;
- (IBAction)newGameTUI:(id)sender;

// Gameplay Methods
-(void) initGame;
-(void) updateBoard;
-(void) updateGameStatus;
-(TTGameOverStatus) checkGameOver;
-(BOOL) didPlayerWin:(NSString *)player;
-(void)endGameWithResult:(TTGameOverStatus)result;

@end
