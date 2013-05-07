//
//  BADSinglePlayerViewController.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADSinglePlayerViewController.h"
#import "BADConstants.h"
#import "BADSetupSingle.h"
#import "BADAchievementView.h"

#define fAlertView1  1
#define fAlertView2  2
#define fAlertView3  3
#define fAlertView4  4
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface BADSinglePlayerViewController ()

@end

@implementation BADSinglePlayerViewController

-(void)SlideSetupOff
{    
    [[NSUserDefaults standardUserDefaults] setValue:self.setup.xPlayerTxtFld.text forKey:XPLAYERTAG];
    
    [self SetNewNames];
    
    NSString *xImageName = [[NSUserDefaults standardUserDefaults] valueForKey:XIMAGES];
    
    xImageName = [xImageName substringToIndex:[xImageName length] - 5];
    
    NSString *difAndImageName = [NSString stringWithFormat:@"image:%@ difficulty:%@", xImageName, difficulty];
    
    [self.tracker sendEventWithCategory:@"singlePlayer"
                             withAction:@"gameStarted"
                              withLabel:difAndImageName
                              withValue:[NSNumber numberWithInt:20]];
    
    [UIView transitionWithView:self.setup.view
                      duration:.5
                       options: (UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut)
                    animations:^{
                        self.setup.view.hidden = YES;
     }
                    completion:^(BOOL finished){
                        [self.setup.view removeFromSuperview];
                        //animCompleteHandlerCode..
                    }
     ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"Single Player";
    //self.adBanner.delegate = self;
    
    self.fireworksEmitter = [CAEmitterLayer layer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SlideSetupOff) name:@"setupBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupBackBtnTUI) name:BACKBTN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementEarned:) name:ACHIEVEMENTEARNED object:nil];
    
    // UI
    self.setup = [[BADSetupSingle alloc] initWithNibName:@"BADSetupSingle" bundle:nil];
    
    self.setup.oPlayerTxt.hidden = NO;
    self.setup.oPlayerTxtFld.hidden = YES;
    
    CGRect f = self.setup.view.frame;
    f.origin.x = 0;
    f.origin.y = 0;
    f.size.height = 480;
    
    if(IS_IPHONE_5) f.size.height += 64;
    
    self.setup.view.frame = f;
    
    [self.view addSubview:self.setup.view];
    firstPlayer = YES;
    
    [self createAdBanner];
    
    //_spaceButton = _spaceButton objectAtIndex
    
    _spaceButton = [_spaceButton sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
    
    _theGameState = [[BADGameState alloc] init];
}

-(void)StartCrowd
{
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fireworks.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [self.backgroundMusicPlayer setDelegate:self];
    [self.backgroundMusicPlayer setNumberOfLoops:-1];
    
    self.backgroundMusicPlayer.volume = .9;
    
    [self.backgroundMusicPlayer prepareToPlay];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON]==YES)
    {
        [self.backgroundMusicPlayer play];
    }
}

-(void)StopCrowd
{
    [self.backgroundMusicPlayer stop];
}

-(void)createAdBanner
{
    ADBannerView *myBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 460, 320, 50)];
    myBanner.delegate = self;
    [self.view addSubview:myBanner];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!banner.hidden && self.animation == NO)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
//        CGRect f = self.setup.view.frame;
//        f.size.height -= 50;
//        self.setup.view.frame = f;
        [UIView commitAnimations];
        banner.hidden = NO;
        self.animation = YES;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (!banner.hidden)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectMake(460, 0, banner.frame.size.width, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = YES;

        self.animation = NO;
    }
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    //[self onStopPressed];
    
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    //[self onStartPressed];
}

-(void)achievementEarned:(NSNotification *)notification
{
    NSString *key = @"NotifName";
    NSDictionary *dictionary = [notification userInfo];
    NSString *name = [dictionary valueForKey:key];
    [self achievementName:name];
}

-(void)achievementName:(NSString *)name
{
    BADAchievementView *temporaryView = (BADAchievementView *)[[[NSBundle mainBundle] loadNibNamed:@"BADAchievementView" owner:self options:nil] objectAtIndex:0];
    
    CGRect f = temporaryView.frame;
    f.origin.x = 90;
    f.origin.y = -30;
    temporaryView.frame = f;
    temporaryView.achievementLbl.text = name;
    
    [self.view addSubview:temporaryView];
    
    [temporaryView setAppear];
    
    [self.tracker sendEventWithCategory:@"achievement"
                             withAction:@"achievementEarned"
                              withLabel:name
                              withValue:[NSNumber numberWithInt:20]];
    if([name isEqualToString:@"Under 5 Easy"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlocked Bling XO Pieces!" message:@"\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Continue Playing" otherButtonTitles:@"See Achievement", nil];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Setup Bling XO Pair.png"]];
        CGRect ff = imageView.frame;
        ff.origin.x = 95;
        ff.origin.y = 48;
        imageView.frame = ff;
        [alert addSubview:imageView];
        alert.tag = fAlertView4;
        [alert show];
    }
}

-(void)SetNewNames
{
    self.xPlayerName = [[NSUserDefaults standardUserDefaults] valueForKey:XPLAYERTAG];
    difficulty = [[NSUserDefaults standardUserDefaults] valueForKey:DIFFICULTY];
    
    self.oPlayerName = [NSString stringWithFormat:@"%@", difficulty];
    
    self.xPlayerLbl.text = self.xPlayerName;
    self.oPlayerLbl.text = self.oPlayerName;
    
    NSString *xImageName = [[NSUserDefaults standardUserDefaults] valueForKey:XIMAGES];
    NSString *oImageName = [[NSUserDefaults standardUserDefaults] valueForKey:OIMAGES];
    
    _xImage = [UIImage imageNamed:xImageName];//pieceX.png
    _oImage = [UIImage imageNamed:oImageName];//pieceO.png
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initGame];
}

-(void)turnXTUI
{
    self.turnXBtn.selected = YES;
    self.turnOBtn.selected = NO;
}

-(void)setupBackBtnTUI
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backBtnTUI:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SHOW_ARE_YOU_SURE_AV"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SHOW_ARE_YOU_SURE_AV"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:[NSString stringWithFormat:@"Be careful!  Pressing Back counts as a loss!  Are you sure you want to gack out of the game?"]
                                                       delegate:self
                                              cancelButtonTitle:[NSString stringWithFormat:@"Keep Playing"]
                                              otherButtonTitles:@"Back Out", nil];
        
        
        alert.tag = fAlertView3;
        [alert show];
    }else{
        if([difficulty isEqualToString:@"Hard"])
        {
            int lossVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSHARD];
            lossVsHard++;
            [[NSUserDefaults standardUserDefaults] setInteger:lossVsHard forKey:LOSSVSHARD];
        }else if([difficulty isEqualToString:@"Easy"])
        {
            int lossVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSEASY];
            lossVsEasy++;
            [[NSUserDefaults standardUserDefaults] setInteger:lossVsEasy forKey:LOSSVSEASY];
        }else if([difficulty isEqualToString:@"Medium"])
        {
            int lossVsMedium = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSMEDIUM];
            lossVsMedium++;
            [[NSUserDefaults standardUserDefaults] setInteger:lossVsMedium forKey:LOSSVSMEDIUM];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)turnOTUI
{
    self.turnOBtn.selected = YES;
    self.turnXBtn.selected = NO;
}

-(void)initGame
{
    if(firstPlayer)
    {
        self.theGameState.playersTurn = TTxPlayerTurn;
        //self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.xPlayerName];
        [self turnXTUI];
        
    }else{
        self.theGameState.playersTurn = TToPlayerTurn;
        //self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.oPlayerName];
        [self turnOTUI];
    }
    
    trappedSide = false;
    timerStatus = TTTimerOff;
    firstPlayer = !firstPlayer;
    
    [self.theGameState.boardState removeAllObjects];
    for (int i = 0; i<=8; i++) {
        [self.theGameState.boardState insertObject:@" " atIndex:i];
    }
    
    [self updateBoard];
}

-(void)newGameTUI:(id)sender
{
    [self onStopPressed];
    [self endGameWithResult:TTGameOveroWins];
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
        [[self.theGameState.boardState objectAtIndex:2]  isEqualToString:player])
       
       ||
       
       ([[self.theGameState.boardState objectAtIndex:3]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:5]  isEqualToString:player])
       
       ||
       
       ([[self.theGameState.boardState objectAtIndex:6]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:7]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:8]  isEqualToString:player])
       
       
       ||
       
       
       ([[self.theGameState.boardState objectAtIndex:0]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:3]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:6]  isEqualToString:player])
       
       ||
       
       ([[self.theGameState.boardState objectAtIndex:1]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:7]  isEqualToString:player])
       
       ||
       
       ([[self.theGameState.boardState objectAtIndex:2]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:5]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:8]  isEqualToString:player])
       
       
       ||
       
       
       ([[self.theGameState.boardState objectAtIndex:0]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:4]  isEqualToString:player] &&
        [[self.theGameState.boardState objectAtIndex:8]  isEqualToString:player])
       
       ||
       
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
            [self turnOTUI];
            //[self onStartPressed:sender];
        }
        else
        {
            [self.theGameState.boardState replaceObjectAtIndex:index withObject:@"o"];
            self.theGameState.playersTurn = TTxPlayerTurn;
            [self turnXTUI];
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
                //self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.xPlayerName];
                [self enableUserInteraction];
            }
            else
            {
                //self.statusLabel.text = [NSString stringWithFormat:@"%@ to move", self.oPlayerName];
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
    NSString *winLossTie = @"";
    
    switch (result) {
        case TTGameOverxWins:
            [self startFireWorks];
            [self StartCrowd];
            winLossTie = @"win";
            gameOverMessage = [NSString stringWithFormat:@"%@ wins!", self.xPlayerName];
            if([difficulty isEqualToString:@"Hard"])
            {
                int winsVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD];
                winsVsHard++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsHard forKey:WINSVSHARD];
            }else if([difficulty isEqualToString:@"Easy"])
            {
                int winsVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSEASY];
                winsVsEasy++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsEasy forKey:WINSVSEASY];
            }else if([difficulty isEqualToString:@"Medium"])
            {
                int winsVsMedium = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSMEDIUM];
                winsVsMedium++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsMedium forKey:WINSVSMEDIUM];
            }
            break;
        case TTGameOveroWins:
            gameOverMessage = [NSString stringWithFormat:@"%@ wins!", self.oPlayerName];
            winLossTie = @"loss";
            if([difficulty isEqualToString:@"Hard"])
            {
                int lossVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSHARD];
                lossVsHard++;
                [[NSUserDefaults standardUserDefaults] setInteger:lossVsHard forKey:LOSSVSHARD];
            }else if([difficulty isEqualToString:@"Easy"])
            {
                int lossVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSEASY];
                lossVsEasy++;
                [[NSUserDefaults standardUserDefaults] setInteger:lossVsEasy forKey:LOSSVSEASY];
            }else if([difficulty isEqualToString:@"Medium"])
            {
                int lossVsMedium = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSMEDIUM];
                lossVsMedium++;
                [[NSUserDefaults standardUserDefaults] setInteger:lossVsMedium forKey:LOSSVSMEDIUM];
            }
            
            break;
        case TTGameOverTie:
            gameOverMessage = @"The game is a tie";
            winLossTie = @"tie";
            if([difficulty isEqualToString:@"Hard"])
            {
                int tieVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:TIEVSHARD];
                tieVsHard++;
                [[NSUserDefaults standardUserDefaults] setInteger:tieVsHard forKey:TIEVSHARD];
            }else if([difficulty isEqualToString:@"Easy"])
            {
                int tieVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:TIEVSEASY];
                tieVsEasy++;
                [[NSUserDefaults standardUserDefaults] setInteger:tieVsEasy forKey:TIEVSEASY];
            }else if([difficulty isEqualToString:@"Medium"])
            {
                int tieVsMedium = [[NSUserDefaults standardUserDefaults] integerForKey:TIEVSMEDIUM];
                tieVsMedium++;
                [[NSUserDefaults standardUserDefaults] setInteger:tieVsMedium forKey:TIEVSMEDIUM];
            }
            
            break;
            default:
            break;
        case TTGameOveroWinsTime:
            gameOverMessage = [NSString stringWithFormat:@"%@ has a quicker time!  %@ wins!", self.oPlayerName, self.oPlayerName];
            winLossTie = @"loss";
            if([difficulty isEqualToString:@"Hard"])
            {
                int lossVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSHARD];
                lossVsHard++;
                [[NSUserDefaults standardUserDefaults] setInteger:lossVsHard forKey:LOSSVSHARD];
            }else if([difficulty isEqualToString:@"Easy"])
            {
                int lossVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSEASY];
                lossVsEasy++;
                [[NSUserDefaults standardUserDefaults] setInteger:lossVsEasy forKey:LOSSVSEASY];
            }else if([difficulty isEqualToString:@"Medium"])
            {
                int lossVsMedium = [[NSUserDefaults standardUserDefaults] integerForKey:LOSSVSMEDIUM];
                lossVsMedium++;
                [[NSUserDefaults standardUserDefaults] setInteger:lossVsMedium forKey:LOSSVSMEDIUM];
            }
            
            break;
        case TTGameOverxWinsTime:
            [self startFireWorks];
            [self StartCrowd];
            winLossTie = @"win";
            gameOverMessage = [NSString stringWithFormat:@"%@ has a quicker time!  %@ wins!", self.xPlayerName, self.xPlayerName];
            if([difficulty isEqualToString:@"Hard"])
            {
                int winsVsHard = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD];
                winsVsHard++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsHard forKey:WINSVSHARD];
            }else if([difficulty isEqualToString:@"Easy"])
            {
                int winsVsEasy = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSEASY];
                winsVsEasy++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsEasy forKey:WINSVSEASY];
            }else if([difficulty isEqualToString:@"Medium"])
            {
                int winsVsMedium = [[NSUserDefaults standardUserDefaults] integerForKey:WINSVSMEDIUM];
                winsVsMedium++;
                [[NSUserDefaults standardUserDefaults] setInteger:winsVsMedium forKey:WINSVSMEDIUM];
            }
            break;
    }
    
    NSNumber *num = [NSNumber numberWithFloat:[self.timerX.text floatValue]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:num forKey:@"time"];
    [dict setObject:difficulty forKey:@"difficulty"];
    [dict setObject:winLossTie forKey:@"winLossTie"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECKFORACHIEVEMENT object:nil userInfo:dict];
    
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
                                                        message:[NSString stringWithFormat:@"Computer will start"]
                                                       delegate:self
                                              cancelButtonTitle:[NSString stringWithFormat:@"Start Game"]
                                              otherButtonTitles:@"End Game", nil];
        alert.tag = fAlertView2;
        [alert show];
    }else if(alertView.tag == fAlertView2)
    {
        if(buttonIndex == 0)
        {
            [self.tracker sendEventWithCategory:@"singlePlayer"
                                     withAction:@"newGamePressed"
                                      withLabel:@"nil"
                                      withValue:[NSNumber numberWithInt:20]];
            
            [self resetTimer];
            [self initGame];
            [self endFireWorks];
            [self StopCrowd];
            
            
            
            if(firstPlayer)
                [self computersTurn:YES];
            else
                [self enableUserInteraction];
        }else if(buttonIndex == 1)
        {
            NSLog(@"back button");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(alertView.tag == fAlertView3)
    {
        if(buttonIndex == 1)
            [self backBtnTUI:nil];
    }else if(alertView.tag == fAlertView4)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"See Achievement button tap");
            //[self.navigationController popViewControllerAnimated:YES];
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
    if([difficulty isEqualToString:@"Easy"])
        rndNum = (double)((rand() % 250) + 100) / 100;
    else if([difficulty isEqualToString:@"Hard"])
        rndNum = (double)((rand() % 100) + 10) / 100;
    else if([difficulty isEqualToString:@"Medium"])
        rndNum = (double)((rand() % 200) + 50) / 100;
    
    if(inPlay)
         [self finishComputerTurn];
    else
        [self performSelector:@selector(finishComputerTurn) withObject:nil afterDelay:rndNum];
}

-(void)finishComputerTurn
{
    int compTurnIndex = [self getIndex];
    [self buttonTapIndex:compTurnIndex];
}

-(int)getIndex
{
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
    
    if([difficulty isEqualToString:@"Hard"])
    {
        if(xCount == 0)
        {
            int odds = arc4random_uniform(100);
            if(odds < 40)
            {
                int spot[5] = {0,2,4,6,8};
                return [self randomNumberThatIsNot:spot];
            }else if(odds  >= 40 && odds < 50)
            {
                int spot[4] = {1,3,5,7};
                return [self randomNumberThatIsNot:spot];
            }else
            {
                return 4;
            }
        }
        
        int winSpot = [self winSpot];
        if(winSpot != -1) return winSpot;
        
        int blockSpot = [self canBlock];
        if(blockSpot != -1) return blockSpot;
        
        if(oCount == 1  && xCount == 1)
        {
            if([three isEqualToString:o])
            {
                if([one isEqualToString:x] || [two isEqualToString:x])
                {
                    trappedSide = true;
                    return 0;
                }
                if([seven isEqualToString:x] || [eight isEqualToString:x])
                {
                    trappedSide = true;
                    return 6;
                }
            }
            
            if([five isEqualToString:o])
            {
                if([zero isEqualToString:x] || [one isEqualToString:x])
                {
                     trappedSide = true;
                     return 2;
                }
                if([six isEqualToString:x] || [seven isEqualToString:x])
                {
                    trappedSide = true;
                    return 8;
                }
            }
            
            if([one isEqualToString:o])
            {
                if([three isEqualToString:x] || [six isEqualToString:x])
                {
                    trappedSide = true;
                    return 0;
                }
                if([five isEqualToString:x] || [eight isEqualToString:x])
                {
                    trappedSide = true;
                    return 2;
                }
            }
            
            if([seven isEqualToString:o])
            {
                if([zero isEqualToString:x] || [three isEqualToString:x])
                {
                    trappedSide = true;
                    return 6;
                }
                if([two isEqualToString:x] || [five isEqualToString:x])
                {
                    trappedSide = true;
                    return 8;
                }
            }
            
            int odds = arc4random_uniform(100);
            if(odds < 92)
            {
                if([four isEqualToString:o])
                {
                    if([zero isEqualToString:x])
                    {
                        return 8;
                    }
                    
                    if([two isEqualToString:x])
                    {
                        return 6;
                    }
                    
                    if([six isEqualToString:x])
                    {
                        return 2;
                    }
                    
                    if([eight isEqualToString:x])
                    {
                        return 0;
                    }
                }
            }
            
            if([zero isEqualToString:o])
            {
                
            }
            
            if([two isEqualToString:o])
            {
                
            }
            
            if([six isEqualToString:o])
            {
                
            }
            
            if([eight isEqualToString:o])
            {
                
            }
        }
        
        if(trappedSide == true) return 4;
        
        if(oCount == 2 && xCount == 2)
        {
            if([four isEqualToString:o])
            {
                if([zero isEqualToString:o] && [eight isEqualToString:x])
                {
                    if([one isEqualToString:x])
                    {
                        return 6;
                    }
                    
                    if([three isEqualToString:x])
                    {
                        return 2;
                    }
                }
                
                if([two isEqualToString:o] && [six isEqualToString:x])
                {
                    if([five isEqualToString:x])
                    {
                        return 0;
                    }
                    
                    if([one isEqualToString:x])
                    {
                        return 8;
                    }
                }
                
                if([eight isEqualToString:o] && [zero isEqualToString:x])
                {
                    if([seven isEqualToString:x])
                    {
                        return 2;
                    }
                    
                    if([five isEqualToString:x])
                    {
                        return 6;
                    }
                }
                
                if([six isEqualToString:o] && [two isEqualToString:x])
                {
                    if([seven isEqualToString:x])
                    {
                        return 0;
                    }
                    
                    if([three isEqualToString:x])
                    {
                        return 8;
                    }
                }
            }
        }
        
        if(oCount == 2)
        {
            int blockSpot = [self canBlock];
            if(blockSpot != -1) return blockSpot;
            
            if([zero isEqualToString:o] && [eight isEqualToString:o] && ([two isEqualToString:s] || [six isEqualToString:s]))
            {
                int spots[7] = {0,1,3,4,5,7,8};
                return [self randomNumberThatIsNot:spots];
            }
            
            if([two isEqualToString:o] && [six isEqualToString:o] && ([zero isEqualToString:s] || [eight isEqualToString:s]))
            {
                int spots[7] = {1,2,3,4,5,6,7};
                return [self randomNumberThatIsNot:spots];
            }
        }
        
        if(xCount == 1)
        {
            if([four isEqualToString:s])
            {
                int odds = arc4random_uniform(100);
                if(odds < 90)
                {
                    if([zero isEqualToString:x] || [two isEqualToString:x] || [six isEqualToString:x] || [eight isEqualToString:x])
                    {
                        return 4;
                    }
                    
                    int spots[4] = {0,2,6,8};
                    return [self randomNumberThatIsNot:spots];
                }
            }
            
            if([four isEqualToString:x])
            {
                int odds = arc4random_uniform(100);
                if(odds < 90)
                {
                    int spots[4] = {1,3,5,7};
                    return [self randomNumberThatIsNot:spots];
                }
            }
            
            return [self validRandomSpot];
        }
        
        if(xCount == 2)
        {
            if([four isEqualToString:o])
            {
                if([zero isEqualToString:x] && [eight isEqualToString:x])
                {
                    int spots[2] = {2,6};
                    return [self randomNumberThatIsNot:spots];
                }
                
                if([two isEqualToString:x] && [six isEqualToString:x])
                {
                    int spots[2] = {0,8};
                    return [self randomNumberThatIsNot:spots];
                }
            }
            
            if([four isEqualToString:x])
            {
                if([zero isEqualToString:x] || [two isEqualToString:x] || [six isEqualToString:x] || [eight isEqualToString:x])
                {
                    int spots[4] = {1,3,5,7};
                    return [self randomNumberThatIsNot:spots];
                }
            }
        }
        
        if(oCount == 2)
        {
            if([zero isEqualToString:o] && [eight isEqualToString:o] && ([two isEqualToString:s] || [six isEqualToString:s]))
            {
                int spots[7] = {0,1,3,4,5,7,8};
                int spot = [self randomNumberThatIsNot:spots];
                return spot;
            }
            
            if([two isEqualToString:o] && [six isEqualToString:o] && ([zero isEqualToString:s] || [eight isEqualToString:s]))
            {
                int spots[2] = {0,8};
                int spot = [self randomNumberThatIsNot:spots];
                return spot;
            }
        }
        
        return [self validRandomSpot];
    }else if([difficulty isEqualToString:@"Easy"])
    {
        int odds = arc4random_uniform(100);
        if(odds < 95)
        {
            int winSpot = [self winSpot];
            if(winSpot != -1) return winSpot;
        }
        
        int odds2 = arc4random_uniform(100);
        if(odds2 < 75)
        {
            int blockSpot = [self canBlock];
            if(blockSpot != -1) return blockSpot;
        }
        
        return [self validRandomSpot];
    }else if([difficulty isEqualToString:@"Medium"])
    {
        if(xCount == 0)
        {
            int odds = arc4random_uniform(100);
            if(odds < 15)
            {
                int spot[5] = {0,2,4,6,8};
                return [self randomNumberThatIsNot:spot];
            }else if(odds  >= 16 && odds < 68)
            {
                int spot[4] = {1,3,5,7};
                return [self randomNumberThatIsNot:spot];
            }else if(odds >= 68)
            {
                return 4;
            }
        }
        
        int winSpot = [self winSpot];
        if(winSpot != -1) return winSpot;
        
        int blockSpot = [self canBlock];
        if(blockSpot != -1) return blockSpot;
        
        if(oCount == 1  && xCount == 1)
        {
            if([three isEqualToString:o])
            {
                if([one isEqualToString:x] || [two isEqualToString:x])
                {
                    trappedSide = true;
                    return 0;
                }
                if([seven isEqualToString:x] || [eight isEqualToString:x])
                {
                    trappedSide = true;
                    return 6;
                }
            }
            
            if([five isEqualToString:o])
            {
                if([zero isEqualToString:x] || [one isEqualToString:x])
                {
                    trappedSide = true;
                    return 2;
                }
                if([six isEqualToString:x] || [seven isEqualToString:x])
                {
                    trappedSide = true;
                    return 8;
                }
            }
            
            if([one isEqualToString:o])
            {
                if([three isEqualToString:x] || [six isEqualToString:x])
                {
                    trappedSide = true;
                    return 0;
                }
                if([five isEqualToString:x] || [eight isEqualToString:x])
                {
                    trappedSide = true;
                    return 2;
                }
            }
            
            if([seven isEqualToString:o])
            {
                if([zero isEqualToString:x] || [three isEqualToString:x])
                {
                    trappedSide = true;
                    return 8;
                }
                if([two isEqualToString:x] || [five isEqualToString:x])
                {
                    trappedSide = true;
                    return 6;
                }
            }
            
            int odds = arc4random_uniform(100);
            if(odds < 70)
            {
                if([four isEqualToString:o])
                {
                    if([zero isEqualToString:x])
                    {
                        return 8;
                    }
                    
                    if([two isEqualToString:x])
                    {
                        return 6;
                    }
                    
                    if([six isEqualToString:x])
                    {
                        return 2;
                    }
                    
                    if([eight isEqualToString:x])
                    {
                        return 0;
                    }
                }
            }
        }
        
        if(trappedSide == true && [four isEqualToString:o]) return 4;
        
        return [self validRandomSpot];
    }
    
    return 0;
}

-(int)randomNumberThatIsNot:(int[])arrInt
{
    int rnd;
    do{
        rnd = [self validRandomSpot];
    }while (rnd == arrInt[0] || rnd == arrInt[1] || rnd == arrInt[2] || rnd == arrInt[3] || rnd == arrInt[4] || rnd == arrInt[5] || rnd == arrInt[6] || rnd == arrInt[7] || rnd == arrInt[8]);
    
    return rnd;
}

-(int)winSpot
{
    NSString *o = @"o";
    NSString *s = @" ";
    
    NSString *zero = [self.theGameState.boardState objectAtIndex:0];
    NSString *one = [self.theGameState.boardState objectAtIndex:1];
    NSString *two = [self.theGameState.boardState objectAtIndex:2];
    NSString *three = [self.theGameState.boardState objectAtIndex:3];
    NSString *four = [self.theGameState.boardState objectAtIndex:4];
    NSString *five = [self.theGameState.boardState objectAtIndex:5];
    NSString *six = [self.theGameState.boardState objectAtIndex:6];
    NSString *seven = [self.theGameState.boardState objectAtIndex:7];
    NSString *eight = [self.theGameState.boardState objectAtIndex:8];
    
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
    
    return -1;
}

-(int)canBlock
{
    NSString *x = @"x";
    NSString *s = @" ";
    
    NSString *zero = [self.theGameState.boardState objectAtIndex:0];
    NSString *one = [self.theGameState.boardState objectAtIndex:1];
    NSString *two = [self.theGameState.boardState objectAtIndex:2];
    NSString *three = [self.theGameState.boardState objectAtIndex:3];
    NSString *four = [self.theGameState.boardState objectAtIndex:4];
    NSString *five = [self.theGameState.boardState objectAtIndex:5];
    NSString *six = [self.theGameState.boardState objectAtIndex:6];
    NSString *seven = [self.theGameState.boardState objectAtIndex:7];
    NSString *eight = [self.theGameState.boardState objectAtIndex:8];
    
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
    
    return -1;
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

-(void)endFireWorks
{
    self.birthRate = 0.0;
    [self fireWorks];
    
    //[self.fireWorks disableFireworksWithEmitter:self.fireworksEmitter];
}

-(void)startFireWorks
{
    self.birthRate = 1.0;
    [self fireWorks];
    
    //[self.fireWorks makeFireworksWithBirthRate:1.0 andEmitter:self.fireworksEmitter];
}

-(void)fireWorks
{
    // Cells spawn in the bottom, moving up
	
	CGRect viewBounds = self.view.layer.bounds;
	self.fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
	self.fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
	self.fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
	self.fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
	self.fireworksEmitter.renderMode	= kCAEmitterLayerAdditive;
	self.fireworksEmitter.seed = (arc4random()%100)+1;
	
	// Create the rocket
	CAEmitterCell* rocket = [CAEmitterCell emitterCell];
	
	rocket.birthRate		= self.birthRate; // 1.0
	rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
	rocket.velocity			= 380;
	rocket.velocityRange	= 100;
	rocket.yAcceleration	= 75;
	rocket.lifetime			= 1.06;	// we cannot set the birthrate < 1.0 for the burst
	
	rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
	rocket.scale			= 0.2;
	rocket.color			= [[UIColor redColor] CGColor];
	rocket.greenRange		= 1.0;		// different colors
	rocket.redRange			= 1.0;
	rocket.blueRange		= 1.0;
	rocket.spinRange		= M_PI;		// slow spin
	
    
	
	// the burst object cannot be seen, but will spawn the sparks
	// we change the color here, since the sparks inherit its value
	CAEmitterCell* burst = [CAEmitterCell emitterCell];
	
	burst.birthRate			= self.birthRate;		// at the end of travel
	burst.velocity			= 0;
	burst.scale				= 2.5;
	burst.redSpeed			=-1.5;		// shifting
	burst.blueSpeed			=+1.5;		// shifting
	burst.greenSpeed		=+1.0;		// shifting
	burst.lifetime			= 0.35;
	
	// and finally, the sparks
	CAEmitterCell* spark = [CAEmitterCell emitterCell];
	
	spark.birthRate			= 400;
	spark.velocity			= 125;// 125
	spark.emissionRange		= 2* M_PI;	// 360 deg
	spark.yAcceleration		= 75;		// gravity
	spark.lifetime			= 3;
    
	spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
	spark.scaleSpeed		=-0.2;
	spark.greenSpeed		=-0.1;
	spark.redSpeed			= 0.4;
	spark.blueSpeed			=-0.1;
	spark.alphaSpeed		=-0.25;
	spark.spin				= 2* M_PI;
	spark.spinRange			= 2* M_PI;
	
	// putting it together
	self.fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
	rocket.emitterCells				= [NSArray arrayWithObject:burst];
	burst.emitterCells				= [NSArray arrayWithObject:spark];
	[self.view.layer addSublayer:self.fireworksEmitter];
}

@end
