//
//  BADMultiplayerViewController.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADMultiplayerViewController.h"

@interface BADMultiplayerViewController ()

@end

@implementation BADMultiplayerViewController

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
    
    //_spaceButton = _spaceButton objectAtIndex
    
    self.trackedViewName = @"Online";
    
    _spaceButton = [_spaceButton sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
    
    _xImage = [UIImage imageNamed:@"pieceX.png"];
    _oImage = [UIImage imageNamed:@"pieceO.png"];
    
    _theGameState = [[BADGameState alloc] init];
    
    _myShape = TTMyShapeUndetermined;
    
    _myUUID = [self getUUIDString];
}

-(NSString *)getUUIDString
{
    NSString *result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    
    result = [NSString stringWithFormat:@"%@", uuidStr];
    
    //if(uuidStr) CFRelease(uuidStr); // try uncommenting these two lines
    //if(uuid) CFRelease(uuid);
    
    return result;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initGame];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    
    [picker show];
}

-(void)initGame
{
    self.theGameState.playersTurn = TTxPlayerTurn;
    
    self.statusLabel.text = @"X to move";
    
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
    
    return TTGameOverTie;
}

- (IBAction)spaceButtonTapped:(id)sender
{
    //NSLog(@"Player Tapped: %i ", [sender tag]);
    
    int spaceIndex = [sender tag];
    
    if([[self.theGameState.boardState objectAtIndex:spaceIndex] isEqualToString:@" "] && self.myShape == self.theGameState.playersTurn)
    {
        if(self.theGameState.playersTurn == TTxPlayerTurn)
        {
            [self.theGameState.boardState replaceObjectAtIndex:spaceIndex withObject:@"x"];
            self.theGameState.playersTurn = TToPlayerTurn;
        }
        else
        {
            [self.theGameState.boardState replaceObjectAtIndex:spaceIndex withObject:@"o"];
            self.theGameState.playersTurn = TTxPlayerTurn;
        }
        
        [self updateBoard];
        
        [self updateGameStatus];
        
        NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:self.theGameState];
        NSError *error;
        
        [self.theSession sendDataToAllPeers:theData withDataMode:GKSendDataReliable error:&error];
    }
}

- (IBAction)backBtnTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    self.theSession = session;
    
    self.myPeerID = peerID;
    
    [session setDataReceiveHandler:self withContext:nil];
    
    [picker dismiss];
    
    NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:self.myUUID];
    NSError *error;
    
    [self.theSession sendDataToAllPeers:theData withDataMode:GKSendDataReliable error:&error];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer
           inSession: (GKSession *)session context:(void *)context
{
    // The receive data handler
    NSLog(@"Received data");
    
    // If myShape == TTMyShapeUndetermined we should get shape negotiation data
    if (_myShape == TTMyShapeUndetermined)
    {
        NSString* peerUUID = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([_myUUID compare:peerUUID] == NSOrderedAscending)
        {
            _myShape = TTMyShapeX;
            self.playerLabel.text = @"You are X";
        }
        else
        {
            _myShape = TTMyShapeO;
            self.playerLabel.text = @"You are O";
        }
    }
    else
    {
        // Update the board state with the received data
        self.theGameState = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
        
        // Received data so update the board and the game status
        [self updateBoard];
        [self updateGameStatus];// This is where you'll need to call the stopwatch methods
    }
}

-(void)updateGameStatus
{
    TTGameOverStatus gameOverStatus = [self checkGameOver];
    
    switch (gameOverStatus) {
        case TTGameNotOver:
            if(self.theGameState.playersTurn == TTxPlayerTurn)
            {
                self.statusLabel.text = @"X to move";
            }
            else
            {
                self.statusLabel.text = @"O to move";
            }
            break;
        case TTGameOverxWins:
        case TTGameOveroWins:
        case TTGameOverTie:
            [self endGameWithResult:gameOverStatus];
            break;
    }
}

-(void)endGameWithResult:(TTGameOverStatus)result
{
    NSString *gameOverMessage;
    
    switch (result) {
        case TTGameOverxWins:
            gameOverMessage = @"X wins";
            break;
            
        case TTGameOveroWins:
            gameOverMessage = @"O wins";
            break;
        case TTGameOverTie:
            gameOverMessage = @"The game is a tie";
            break;
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                    message:gameOverMessage
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self initGame];
}

@end
