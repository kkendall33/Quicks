//
//  BADMultiplayerViewController.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "BADGameState.h"
#import "GAITrackedViewController.h"

typedef enum
{
    TTMyShapeUndetermined = 0,
    TTMyShapeX = 1,
    TTMyShapeO = 2
} TTMyShape;

typedef enum {
    TTGameNotOver = 0,
    TTGameOverxWins = 1,
    TTGameOveroWins = 2,
    TTGameOverTie = 3
}TTGameOverStatus;

@interface BADMultiplayerViewController : GAITrackedViewController<UIAlertViewDelegate, GKPeerPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *spaceButton;
@property (weak, nonatomic) IBOutlet UILabel *timerO;
@property (weak, nonatomic) IBOutlet UILabel *timerX;
@property (strong, nonatomic) UIImage * xImage;
@property (strong, nonatomic) UIImage * oImage;
@property (strong, nonatomic) BADGameState *theGameState;

// Network Connection Stuff
@property TTMyShape myShape;
@property (strong, nonatomic) NSString *myUUID;

@property (strong, nonatomic) IBOutlet GKSession *theSession;
@property (strong, nonatomic) IBOutlet NSString *myPeerID;

// NetworkMethod
-(NSString *)getUUIDString;

// UI Methods
- (IBAction)spaceButtonTapped:(id)sender;
- (IBAction)backBtnTUI:(id)sender;

// Gameplay Methods
-(void) initGame;
-(void) updateBoard;
-(void) updateGameStatus;
-(TTGameOverStatus) checkGameOver;
-(BOOL) didPlayerWin:(NSString *)player;
-(void)endGameWithResult:(TTGameOverStatus)result;


@end
