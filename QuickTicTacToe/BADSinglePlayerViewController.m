//
//  BADSinglePlayerViewController.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADSinglePlayerViewController.h"
#import "BADConstants.h"

#define fAlertView1  1
#define fAlertView2  2

@interface BADSinglePlayerViewController ()

@end

@implementation BADSinglePlayerViewController

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
    
    self.gameIsOnEasy = true;
    
    self.xPlayerName = [[NSUserDefaults standardUserDefaults] valueForKey:XPLAYERTAG];
    NSString *difficulty = [[NSUserDefaults standardUserDefaults] valueForKey:DIFFICULTY];
    
    if([difficulty isEqualToString:@"Easy"])
    {
        self.gameIsOnEasy = true;
    }else if([difficulty isEqualToString:@"Hard"])
    {
        self.gameIsOnEasy = false;
    }
    
    self.oPlayerName = [NSString stringWithFormat:@"%@ Computer", difficulty];
    
    
    
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
    
    [self buttonTapIndex:spaceIndex];
}

-(void)buttonTapIndex:(int)index
{
    if(timerStatus == TTTimerOff) [self onStartPressed];
    
    
    if([[self.theGameState.boardState objectAtIndex:index] isEqualToString:@" "])
    {
        if(self.theGameState.playersTurn == TTxPlayerTurn)
        {
            [self.theGameState.boardState replaceObjectAtIndex:index withObject:@"x"];
            self.theGameState.playersTurn = TToPlayerTurn;
            //[self onStartPressed:sender];
        }
        else
        {
            [self.theGameState.boardState replaceObjectAtIndex:index withObject:@"o"];
            self.theGameState.playersTurn = TTxPlayerTurn;
            //[self onStartPressed:sender];
        }
        
        [self updateBoard];
        
        [self updateGameStatus];
        
    }
}

-(void)enableUserInteraction
{
    for(int i = 0; i < [self.spaceButton count]; i++)
        [[self.spaceButton objectAtIndex:i] setUserInteractionEnabled:YES];
}

-(void)disableUserInteraction
{
    for(int i = 0; i < [self.spaceButton count]; i++)
        [[self.spaceButton objectAtIndex:i] setUserInteractionEnabled:NO];
}

-(void)updateGameStatus
{
    TTGameOverStatus gameOverStatus = [self checkGameOver];
    
    switch (gameOverStatus) {
        case TTGameNotOver:
            if(self.theGameState.playersTurn == TTxPlayerTurn)
            {
                self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.xPlayerName];
                [self enableUserInteraction];
            }
            else
            {
                self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.oPlayerName];
                [self disableUserInteraction];
                [self computersTurn:NO];
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
            if(self.gameIsOnEasy == false)
            {
                int winsVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD];
                winsVsHard++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsHard forKey:WINSVSHARD];
            }else if(self.gameIsOnEasy)
            {
                int winsVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSEASY];
                winsVsEasy++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsEasy forKey:WINSVSEASY];
            }
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
                                              otherButtonTitles:@"End Game", nil];
        alert.tag = fAlertView2;
        [alert show];
    }else
    {
        if(buttonIndex == 0)
        {
            [self resetTimer];
            [self initGame];
            if(firstPlayer)
                [self computersTurn:YES];
            else
                [self enableUserInteraction];
        }else if(buttonIndex == 1)
        {
            NSLog(@"back button");
            [self.navigationController popViewControllerAnimated:YES];
        }
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

#pragma mark - ComputerBrain Methods

-(void)computersTurn:(BOOL)inPlay
{
    double rndNum;
    if(self.gameIsOnEasy)
        rndNum = (double)((rand() % 500) + 100) / 100;
    else if(!self.gameIsOnEasy)
        rndNum = (double)(rand() % 100) / 100;
    
    if(!inPlay)
        [self performSelector:@selector(finishComputerTurn) withObject:nil
                      afterDelay:rndNum];
    else
        [self finishComputerTurn];
}

-(void)finishComputerTurn
{
    int compTurnIndex = [self getIndex];
    
    [self buttonTapIndex:compTurnIndex];
}

-(int)getIndex
{
    int index = 0;
    
    NSString *x = @"x";
    NSString *o = @"o";
    NSString *s = @" ";
    int xCount = 0;
    int oCount = 0;
    
    NSString *zero = [self.theGameState.boardState objectAtIndex:0];
    NSString *one = [self.theGameState.boardState objectAtIndex:1];
    NSString *two = [self.theGameState.boardState objectAtIndex:2];
    NSString *three = [self.theGameState.boardState objectAtIndex:3];
    NSString *four = [self.theGameState.boardState objectAtIndex:4];
    NSString *five = [self.theGameState.boardState objectAtIndex:5];
    NSString *six = [self.theGameState.boardState objectAtIndex:6];
    NSString *seven = [self.theGameState.boardState objectAtIndex:7];
    NSString *eight = [self.theGameState.boardState objectAtIndex:8];
    
    for(int i = 0; i < 9; i++)
    {
        if([[self.theGameState.boardState objectAtIndex:i] isEqualToString:x])
            xCount++;
    }
    
    for(int i = 0; i < 9; i++)
    {
        if([[self.theGameState.boardState objectAtIndex:i] isEqualToString:o])
            oCount++;
    }
    
    if(self.gameIsOnEasy == false)
    {
        if(xCount == 0)
        {
            int rnd = arc4random_uniform(8);
            return rnd;
        }
        
        if(xCount == 1)
        {
            if([four isEqualToString:s])
            {
                int spot;
                do{
                    spot = [self validRandomSpot];
                }while (spot == 1  || spot == 3 || spot == 5 || spot == 7);
                return spot;
            }
            else
            {
                return [self validRandomSpot];
            }
        }
        
//        if(oCount == 2)
//        {
               // horizontal
            if([zero isEqualToString:o] && [two isEqualToString:o] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:o] && [two isEqualToString:o] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:o] && [one isEqualToString:o] && [two isEqualToString:s]) return 2;
            
            if([three isEqualToString:o] && [five isEqualToString:o] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:o] && [five isEqualToString:o] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:o] && [four isEqualToString:o] && [five isEqualToString:s]) return 5;
               
            if([six isEqualToString:o] && [eight isEqualToString:o] && [seven isEqualToString:s]) return 7;
            if([seven isEqualToString:o] && [eight isEqualToString:o] && [six isEqualToString:s]) return 6;
            if([six isEqualToString:o] && [seven isEqualToString:o] && [eight isEqualToString:s]) return 8;
            
               // vertical
            if([zero isEqualToString:o] && [six isEqualToString:o] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:o] && [six isEqualToString:o] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:o] && [three isEqualToString:o] && [six isEqualToString:s]) return 6;
               
            if([one isEqualToString:o] && [seven isEqualToString:o] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:o] && [seven isEqualToString:o] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:o] && [four isEqualToString:o] && [seven isEqualToString:s]) return 7;
               
            if([two isEqualToString:o] && [eight isEqualToString:o] && [five isEqualToString:s]) return 5;
            if([five isEqualToString:o] && [eight isEqualToString:o] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:o] && [five isEqualToString:o] && [eight isEqualToString:s]) return 8;
               
               // diagonal
            if([zero isEqualToString:o] && [four isEqualToString:o] && [eight isEqualToString:s]) return 8;
            if([four isEqualToString:o] && [eight isEqualToString:o] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:o] && [eight isEqualToString:o] && [four isEqualToString:s]) return 4;
               
            if([two isEqualToString:o] && [six isEqualToString:o] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:o] && [six isEqualToString:o] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:o] && [four isEqualToString:o] && [six isEqualToString:s]) return 6;
        //}
        
//        if(xCount == 2)
//        {
            // horizontal
            if([zero isEqualToString:x] && [two isEqualToString:x] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:x] && [two isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [one isEqualToString:x] && [two isEqualToString:s]) return 2;
            
            if([three isEqualToString:x] && [five isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [five isEqualToString:x] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:x] && [four isEqualToString:x] && [five isEqualToString:s]) return 5;
            
            if([six isEqualToString:x] && [eight isEqualToString:x] && [seven isEqualToString:s]) return 7;
            if([seven isEqualToString:x] && [eight isEqualToString:x] && [six isEqualToString:s]) return 6;
            if([six isEqualToString:x] && [seven isEqualToString:x] && [eight isEqualToString:s]) return 8;
            
            // vertical
            if([zero isEqualToString:x] && [six isEqualToString:x] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:x] && [six isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [three isEqualToString:x] && [six isEqualToString:s]) return 6;
            
            if([one isEqualToString:x] && [seven isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [seven isEqualToString:x] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:x] && [four isEqualToString:x] && [seven isEqualToString:s]) return 7;
            
            if([two isEqualToString:x] && [eight isEqualToString:x] && [five isEqualToString:s]) return 5;
            if([five isEqualToString:x] && [eight isEqualToString:x] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:x] && [five isEqualToString:x] && [eight isEqualToString:s]) return 8;
            
            // diagonal
            if([zero isEqualToString:x] && [four isEqualToString:x] && [eight isEqualToString:s]) return 8;
            if([four isEqualToString:x] && [eight isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [eight isEqualToString:x] && [four isEqualToString:s]) return 4;
            
            if([two isEqualToString:x] && [six isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [six isEqualToString:x] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:x] && [four isEqualToString:x] && [six isEqualToString:s]) return 6;
        //}
        
        if(oCount == 3)
        {
            // horizontal
            if([zero isEqualToString:o] && [two isEqualToString:o] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:o] && [two isEqualToString:o] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:o] && [one isEqualToString:o] && [two isEqualToString:s]) return 2;
            
            if([three isEqualToString:o] && [five isEqualToString:o] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:o] && [five isEqualToString:o] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:o] && [four isEqualToString:o] && [five isEqualToString:s]) return 5;
            
            if([six isEqualToString:o] && [eight isEqualToString:o] && [seven isEqualToString:s]) return 7;
            if([seven isEqualToString:o] && [eight isEqualToString:o] && [six isEqualToString:s]) return 6;
            if([six isEqualToString:o] && [seven isEqualToString:o] && [eight isEqualToString:s]) return 8;
            
            // vertical
            if([zero isEqualToString:o] && [six isEqualToString:o] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:o] && [six isEqualToString:o] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:o] && [three isEqualToString:o] && [six isEqualToString:s]) return 6;
            
            if([one isEqualToString:o] && [seven isEqualToString:o] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:o] && [seven isEqualToString:o] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:o] && [four isEqualToString:o] && [seven isEqualToString:s]) return 7;
            
            if([two isEqualToString:o] && [eight isEqualToString:o] && [five isEqualToString:s]) return 5;
            if([five isEqualToString:o] && [eight isEqualToString:o] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:o] && [five isEqualToString:o] && [eight isEqualToString:s]) return 8;
            
            // diagonal
            if([zero isEqualToString:o] && [four isEqualToString:o] && [eight isEqualToString:s]) return 8;
            if([four isEqualToString:o] && [eight isEqualToString:o] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:o] && [eight isEqualToString:o] && [four isEqualToString:s]) return 4;
            
            if([two isEqualToString:o] && [six isEqualToString:o] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:o] && [six isEqualToString:o] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:o] && [four isEqualToString:o] && [six isEqualToString:s]) return 6;
        }
        
        if(xCount == 3)
        {
            if([zero isEqualToString:x] && [two isEqualToString:x] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:x] && [two isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [one isEqualToString:x] && [two isEqualToString:s]) return 2;
            
            if([three isEqualToString:x] && [five isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [five isEqualToString:x] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:x] && [four isEqualToString:x] && [five isEqualToString:s]) return 5;
            
            if([six isEqualToString:x] && [eight isEqualToString:x] && [seven isEqualToString:s]) return 7;
            if([seven isEqualToString:x] && [eight isEqualToString:x] && [six isEqualToString:s]) return 6;
            if([six isEqualToString:x] && [seven isEqualToString:x] && [eight isEqualToString:s]) return 8;
            
            // vertical
            if([zero isEqualToString:x] && [six isEqualToString:x] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:x] && [six isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [three isEqualToString:x] && [six isEqualToString:s]) return 6;
            
            if([one isEqualToString:x] && [seven isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [seven isEqualToString:x] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:x] && [four isEqualToString:x] && [seven isEqualToString:s]) return 7;
            
            if([two isEqualToString:x] && [eight isEqualToString:x] && [five isEqualToString:s]) return 5;
            if([five isEqualToString:x] && [eight isEqualToString:x] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:x] && [five isEqualToString:x] && [eight isEqualToString:s]) return 8;
            
            // diagonal
            if([zero isEqualToString:x] && [four isEqualToString:x] && [eight isEqualToString:s]) return 8;
            if([four isEqualToString:x] && [eight isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [eight isEqualToString:x] && [four isEqualToString:s]) return 4;
            
            if([two isEqualToString:x] && [six isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [six isEqualToString:x] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:x] && [four isEqualToString:x] && [six isEqualToString:s]) return 6;
        }
    
        
        return [self validRandomSpot];
    }else if(self.gameIsOnEasy)
    {
        if(xCount == 2)
        {
            if([zero isEqualToString:x] && [two isEqualToString:x] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:x] && [two isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [one isEqualToString:x] && [two isEqualToString:s]) return 2;
            
            if([three isEqualToString:x] && [five isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [five isEqualToString:x] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:x] && [four isEqualToString:x] && [five isEqualToString:s]) return 5;
            
            if([six isEqualToString:x] && [eight isEqualToString:x] && [seven isEqualToString:s]) return 7;
            if([seven isEqualToString:x] && [eight isEqualToString:x] && [six isEqualToString:s]) return 6;
            if([six isEqualToString:x] && [seven isEqualToString:x] && [eight isEqualToString:s]) return 8;
            
            // vertical
            if([zero isEqualToString:x] && [six isEqualToString:x] && [three isEqualToString:s]) return 3;
            if([three isEqualToString:x] && [six isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [three isEqualToString:x] && [six isEqualToString:s]) return 6;
            
            if([one isEqualToString:x] && [seven isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [seven isEqualToString:x] && [one isEqualToString:s]) return 1;
            if([one isEqualToString:x] && [four isEqualToString:x] && [seven isEqualToString:s]) return 7;
            
            if([two isEqualToString:x] && [eight isEqualToString:x] && [five isEqualToString:s]) return 5;
            if([five isEqualToString:x] && [eight isEqualToString:x] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:x] && [five isEqualToString:x] && [eight isEqualToString:s]) return 8;
            
            // diagonal
            if([zero isEqualToString:x] && [four isEqualToString:x] && [eight isEqualToString:s]) return 8;
            if([four isEqualToString:x] && [eight isEqualToString:x] && [zero isEqualToString:s]) return 0;
            if([zero isEqualToString:x] && [eight isEqualToString:x] && [four isEqualToString:s]) return 4;
            
            if([two isEqualToString:x] && [six isEqualToString:x] && [four isEqualToString:s]) return 4;
            if([four isEqualToString:x] && [six isEqualToString:x] && [two isEqualToString:s]) return 2;
            if([two isEqualToString:x] && [four isEqualToString:x] && [six isEqualToString:s]) return 6;
        }
        
        return [self validRandomSpot];
    }
    
    return 0;
}

-(int)validRandomSpot
{
    NSMutableArray *squares = [[NSMutableArray alloc] initWithCapacity:9];
    
    for(int i = 0; i < 9; i++)
    {
        if([[self.theGameState.boardState objectAtIndex:i] isEqualToString:@"x"] || [[self.theGameState.boardState objectAtIndex:i] isEqualToString:@"o"])
        {
            [squares insertObject:[NSNumber numberWithInt:i] atIndex:i];
        }else
        {
            [squares insertObject:[NSNumber numberWithInt:-1] atIndex:i];
        }
    }
    
    int rnd;
    do{
        rnd = arc4random_uniform(9);
    }while (rnd == [[squares objectAtIndex:0] intValue] || rnd == [[squares objectAtIndex:1] intValue] || rnd == [[squares objectAtIndex:2] intValue] || rnd == [[squares objectAtIndex:3] intValue] || rnd == [[squares objectAtIndex:4] intValue] || rnd == [[squares objectAtIndex:5] intValue] || rnd == [[squares objectAtIndex:6] intValue] || rnd == [[squares objectAtIndex:7] intValue] || rnd == [[squares objectAtIndex:8] intValue]);
    
    return rnd;
}

@end
