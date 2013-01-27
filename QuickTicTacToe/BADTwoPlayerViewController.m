//
//  BADTwoPlayerViewController.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/22/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADTwoPlayerViewController.h"
#import "BADConstants.h"

#define fAlertView1  1
#define fAlertView2  2

@interface BADTwoPlayerViewController ()

@end

@implementation BADTwoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.xPlayerName = [[NSUserDefaults standardUserDefaults] valueForKey:XPLAYERTAG];
    self.oPlayerName = [[NSUserDefaults standardUserDefaults] valueForKey:OPLAYERTAG];
    
    self.xPlayerLbl.text = self.xPlayerName;
    self.oPlayerLbl.text = self.oPlayerName;
    
    firstPlayer = YES;
    
    //_spaceButton = _spaceButton objectAtIndex
    
    _spaceButton = [_spaceButton sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
    
    _xImage = [UIImage imageNamed:@"tic-tac-toe-X.png"];
    _oImage = [UIImage imageNamed:@"tic-tac-toe-o.jpg"];
    
    _theGameState = [[BADGameState alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initGame];
}

-(void)initGame
{
    if(firstPlayer)
    {
        self.theGameState.playersTurn = TTxPlayerTurn;
        self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.xPlayerName];
    }else{
        self.theGameState.playersTurn = TToPlayerTurn;
        self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.oPlayerName];
    }
    timerStatus = TTTimerOff;
    
    firstPlayer = !firstPlayer;
    
    [self.theGameState.boardState removeAllObjects];
    for (int i = 0; i<=8; i++) {
        [self.theGameState.boardState insertObject:@" " atIndex:i];
    }
    [self updateBoard];
}

-(void)updateBoard
{
    for(int i = 0; i <=8; i++)
    {
        if([[self.theGameState.boardState objectAtIndex:i] isEqualToString:@"x"])
        {
            [[_spaceButton objectAtIndex:i] setImage:self.xImage forState:UIControlStateNormal];
        }else if([[self.theGameState.boardState objectAtIndex:i] isEqualToString:@"o"])
        {
            [[_spaceButton objectAtIndex:i] setImage:self.oImage forState:UIControlStateNormal];
        }
        else
        {
            [[_spaceButton objectAtIndex:i] setImage:nil forState:UIControlStateNormal];
        }
    }
}

-(BOOL)didPlayerWin:(NSString *)player
{
    if(([[self.theGameState.boardState objectAtIndex:0]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:1]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:2]  isEqualToString:player]) ||
       ([[self.theGameState.boardState objectAtIndex:3]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:5]  isEqualToString:player]) ||
       ([[self.theGameState.boardState objectAtIndex:6]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:7]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:8]  isEqualToString:player]) ||
       
       ([[self.theGameState.boardState objectAtIndex:0]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:3]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:6]  isEqualToString:player]) ||
       ([[self.theGameState.boardState objectAtIndex:1]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:7]  isEqualToString:player]) ||
       ([[self.theGameState.boardState objectAtIndex:2]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:5]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:8]  isEqualToString:player]) ||
       
       ([[self.theGameState.boardState objectAtIndex:0]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:8]  isEqualToString:player]) ||
       ([[self.theGameState.boardState objectAtIndex:2]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:6]  isEqualToString:player])
       
       )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(TTGameOverStatus)checkGameOver
{
    if([self didPlayerWin:@"x"])
    {
        return TTGameOverxWins;
    }
    else if([self didPlayerWin:@"o"])
    {
        return TTGameOveroWins;
    }
    
    
    
    for (int i = 0; i <=8; i++) {
        if([[self.theGameState.boardState objectAtIndex:i] isEqualToString:@" "])
        {
            return TTGameNotOver;
        }
    }
    
    if(decisecondX > decisecondO)
    {
        return TTGameOveroWinsTime;
    }else if(decisecondX < decisecondO)
    {
        return TTGameOverxWinsTime;
    }
    
    return TTGameOverTie;
}

- (IBAction)spaceButtonTapped:(id)sender
{
    //NSLog(@"Player Tapped: %i ", [sender tag]);
    
    int spaceIndex = [sender tag];
    
    if(timerStatus == TTTimerOff) [self onStartPressed];
    
    if([[self.theGameState.boardState objectAtIndex:spaceIndex] isEqualToString:@" "])
    {
        if(self.theGameState.playersTurn == TTxPlayerTurn)
        {
            [self.theGameState.boardState replaceObjectAtIndex:spaceIndex withObject:@"x"];
            self.theGameState.playersTurn = TToPlayerTurn;
            //[self onStartPressed:sender];
        }
        else
        {
            [self.theGameState.boardState replaceObjectAtIndex:spaceIndex withObject:@"o"];
            self.theGameState.playersTurn = TTxPlayerTurn;
            //[self onStartPressed:sender];
        }
        
        [self updateBoard];
        
        [self updateGameStatus];
    }
}

-(void)updateGameStatus
{
    TTGameOverStatus gameOverStatus = [self checkGameOver];
    
    switch (gameOverStatus) {
        case TTGameNotOver:
            if(self.theGameState.playersTurn == TTxPlayerTurn)
            {
                self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.xPlayerName];
            }
            else
            {
                self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.oPlayerName];
            }
            break;
        case TTGameOverxWins:
        case TTGameOveroWins:
        case TTGameOveroWinsTime:
        case TTGameOverxWinsTime:
        case TTGameOverTie:
            [self onStopPressed];
            [self endGameWithResult:gameOverStatus];
            break;
    }
}

-(void)endGameWithResult:(TTGameOverStatus)result
{
    NSString *gameOverMessage;
    
    
    
    switch (result) {
        case TTGameOverxWins:
            gameOverMessage = [NSString stringWithFormat:@"%@ wins!", self.xPlayerName];
            break;
        case TTGameOveroWins:
            gameOverMessage = [NSString stringWithFormat:@"%@ wins!", self.oPlayerName];
            break;
        case TTGameOverTie:
            gameOverMessage = @"The game is a tie";
            break;
        default:
            break;
        case TTGameOveroWinsTime:
            gameOverMessage = [NSString stringWithFormat:@"%@ has a quicker time!  %@ wins!", self.oPlayerName, self.oPlayerName];
            break;
        case TTGameOverxWinsTime:
            gameOverMessage = [NSString stringWithFormat:@"%@ has a quicker time!  %@ wins!", self.xPlayerName, self.xPlayerName];
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                    message:gameOverMessage
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    alert.tag = fAlertView1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == fAlertView1)
    {
        NSString *startingPlayer = @"";
        if(firstPlayer)
            startingPlayer = self.xPlayerName;
        else
            startingPlayer = self.oPlayerName;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Game"
                                                        message:[NSString stringWithFormat:@"%@ will start", startingPlayer]
                                                       delegate:self
                                              cancelButtonTitle:[NSString stringWithFormat:@"Go %@!!", startingPlayer]
                                              otherButtonTitles:nil, nil];
        alert.tag = fAlertView2;
        [alert show];
    }else
    {
        [self resetTimer];
        [self initGame];
    }
}

#pragma mark - StopWatch Methods

- (IBAction)onStartPressed{
    //startDate = [NSDate date];
    
    // Create the stop watch timer that fires every 10 ms
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    timerStatus = TTTimerOn;
}

-(void)resetTimer
{
    decisecondX = 0.0;
    decisecondO = 0.0;
    _timerX.text = [NSString stringWithFormat:@"%.1f",0.0];
    _timerO.text = [NSString stringWithFormat:@"%.1f",0.0];
}

-(void)updateTimer
{
    //    NSDate *currentDate = [NSDate date];
    //    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    //    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"HH:mm:ss.S"];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    //    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    //    _timerX.text = timeString;
    if(self.theGameState.playersTurn == TTxPlayerTurn)
    {
        decisecondX += .1;
        _timerX.text = [NSString stringWithFormat:@"%.1f",decisecondX];
    }else
    {
        decisecondO += .1;
        _timerO.text = [NSString stringWithFormat:@"%.1f",decisecondO];
    }
}

- (IBAction)onStopPressed{
    [stopWatchTimer invalidate];
    stopWatchTimer = nil;
    timerStatus = TTTimerOff;
    
    //[self updateTimer];
}

@end