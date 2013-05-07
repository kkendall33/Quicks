//
//  BADExtrasViewController.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADExtrasViewController.h"
#import "BADAchievements.h"
#import "BADConstants.h"

@interface BADExtrasViewController ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *name;

@end

@implementation BADExtrasViewController

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
    
    self.achievementScrollView.delegate = self;
    
    self.trackedViewName = @"Achievements";
    
//    self.tableViewData = [NSArray arrayWithObjects:@"Win Game Against Easy - Unlock Online Play",@"Win Game Against Medium - Unlock Multiplayer",@"Win Game Against Hard",@"Win 10 Games Against Easy",@"Win 10 Games Against Medium",@"Win 10 Games Against Hard",@"Win a Game in Under 10 Seconds",@"Win Game in Under 5 Seconds",@"Win a Game in under 2 Seconds",@"Win Game in Under 1 second",@"Lose a game in Under .5 seconds", @"Like Quick Tic-Tac Toe Facebook Page",@"Win a Game Online",@"Change X and O Design",@"Win 2-Player Match in 3 moves",@"Win 2 Games in a Row Easy",@"Win 5 Games in a row Easy",@"Win 10 Games in a Row Easy",@"Win 20 Games in a Row Easy - Unlock X/O design",@"Win 2 Games in a Row Medium",@"Win 5 Games in a row Medium",@"Win 10 Games in a Row Medium",@"Win 20 Games in a Row Medium - Unlock X/O design",@"Win 2 Games in a Row Hard",@"Win 5 Games in a row Hard",@"Win 10 Games in a Row Hard",@"Win 20 Games in a Row Hard - Unlock X/O design",@"Win 2 Games in a Row Online",@"Win 5 Games in a row Online",@"Win 10 Games in a Row Online",@"Win 20 Games in a Row Online - Unlock X/O design",@"Win 50 Games on Online",@"Win 100 Games on Online", @"Win 200 Games on Online",@"Win 1,000 Games on Online - Unlock X/O design",@"Win 5,000 Games on Online - Unlock X/O design",@"Win 50 Games on Hard",@"Win 100 Games on Hard", @"Win 200 Games on Hard",@"Win 1,000 Games on Hard - Unlock X/O design",@"Win 5,000 Games on Hard - Unlock X/O design",nil];
    
    self.tableViewData = [NSArray arrayWithObjects:@"Win 5 games", @"Win 10 games", @"Win 25 games", @"Win 100 games", @"Win game in under 10 seconds", @"Win game in under 5 seconds", @"Win game in under 2 seconds", @"Win game in under 1 second", @"Like Our Facebook Page", @"Win 5 in a row", nil];
    
    [self SetStats];
    
//    CGSize f = self.achievementScrollView.contentSize;
//    f.height = 122;
//    f.width = 0;
//    self.achievementScrollView.contentSize = f;
    
    for(int i = 0; i < 10; i++)
    {
        BADAchievements *temporaryView = (BADAchievements *)[[[NSBundle mainBundle] loadNibNamed:@"BADAchievements" owner:self options:nil] objectAtIndex:0];
        
        CGRect f = temporaryView.frame;
        f.size.width = 300;
        f.origin.x = (i * 301);
        //f.size.width = 320;
        temporaryView.frame = f;
        
        CGSize s = self.achievementScrollView.contentSize;
        s.width = f.origin.x + f.size.width;
        [self.achievementScrollView setContentSize:s];
        
//        if(i == 2)
//            [temporaryView.easyImage setImage:[UIImage imageNamed:@"pieceO.png"] forState:UIControlStateNormal];
        
        if(i == 0)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINFIVEEASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINFIVEMED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINFIVEHARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINFIVEONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if (i == 1)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINTENEASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINTENMED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINTENHARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINTENONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if(i == 2)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN25EASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN25MED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN25HARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN25ONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if (i == 3)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN100EASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN100MED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN100HARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN100ONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if (i == 4)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10EASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10MED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10HARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10ONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if (i == 5)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5EASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5MED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5HARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5ONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if (i == 6)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2EASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2MED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2HARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2ONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if (i == 7)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER1EASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER1MED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER1HARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER1ONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }else if(i == 8)
        {
            [temporaryView.easyImage setHidden:YES];
            [temporaryView.mediumImage setHidden:YES];
            [temporaryView.hardImage setHidden:YES];
            [temporaryView.onlineImage setHidden:NO];
            
            [temporaryView.easyLbl setHidden:YES];
            [temporaryView.mediumLbl setHidden:YES];
            [temporaryView.hardLbl setHidden:YES];
            [temporaryView.onlineLbl setHidden:YES];
            
            CGRect f = temporaryView.onlineImage.frame;
            f.origin.x = 124;
            f.size.height = 78;
            f.size.width = 77;
            f.origin.y -= 6;
            temporaryView.onlineImage.frame = f;
            
            [temporaryView.onlineImage setImage:nil forState:UIControlStateNormal];
            [temporaryView.onlineImage setBackgroundImage:[UIImage imageNamed:@"Facebook Badge.png"] forState:UIControlStateNormal];
        }else if(i == 9)
        {
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN5CONSEASY])
                [temporaryView.easyImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN5CONSMED])
                [temporaryView.mediumImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN5CONSHARD])
                [temporaryView.hardImage setEnabled:YES];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:WIN5CONSONLINE])
                [temporaryView.onlineImage setEnabled:YES];
        }
        
        [self.achievementScrollView addSubview:temporaryView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    int pageNum = (offset.x + 160) / 300;
    NSLog(@"%i", pageNum);
    
    self.achievementDesc.text = [self.tableViewData objectAtIndex:pageNum];
    
    if(pageNum == 0)
    {
         [UIView animateWithDuration:0.3 animations:^{
             [self.leftButton setAlpha:0];
         }];
    }else
    {
        //[self.leftButton setHidden:NO];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.leftButton setAlpha:1];
        }];
    }
    
    if(pageNum == [self.tableViewData count]-1)
    {
        //[self.rightButton setHidden:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.rightButton setAlpha:0];
        }];
    }else
    {
        [self.rightButton setHidden:NO];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.rightButton setAlpha:1];
        }];
    }
}

-(void)SetStats
{
    double totalGamesPlayed = 0;
    double totalWinRatio = 0;
    double totalNumWins = 0;
    double onlineGamesPlayed = 0;
    double easyGamesPlayed = 0;
    double mediumGamesPlayed = 0;
    double hardGamesPlayed = 0;
    double easyNumWins = 0;
    double winRatioEasy = 0;
    double onlineNumWins = 0;
    double winRatioOnline = 0;
    double mediumNumWins = 0;
    double winRatioMedium = 0;
    double hardNumWins = 0;
    double winRatioHard = 0;
    double totalWin = 0;
    double totalLoss = 0;
    double totalTie = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int tempInt = [defaults integerForKey:LOSSONLINE];
    self.onlineLossLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    onlineGamesPlayed += tempInt;
    totalLoss += tempInt;
    
    tempInt = [defaults integerForKey:LOSSVSEASY];
    self.easyLossLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    easyGamesPlayed += tempInt;
    totalLoss += tempInt;
    
    tempInt = [defaults integerForKey:LOSSVSMEDIUM];
    self.mediumLossLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    mediumGamesPlayed += tempInt;
    totalLoss += tempInt;
    
    tempInt = [defaults integerForKey:LOSSVSHARD];
    self.hardLossLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    hardGamesPlayed += tempInt;
    totalLoss += tempInt;
    
    tempInt = [defaults integerForKey:WINSONLINE];
    self.onlineWinsLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    totalNumWins += tempInt;
    onlineGamesPlayed += tempInt;
    onlineNumWins += tempInt;
    totalWin += tempInt;
    
    tempInt = [defaults integerForKey:WINSVSEASY];
    self.easyWinsLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    totalNumWins += tempInt;
    easyGamesPlayed += tempInt;
    easyNumWins += tempInt;
    totalWin += tempInt;
    
    tempInt = [defaults integerForKey:WINSVSMEDIUM];
    self.mediumWinsLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    totalNumWins += tempInt;
    mediumGamesPlayed += tempInt;
    mediumNumWins += tempInt;
    totalWin += tempInt;
    
    tempInt = [defaults integerForKey:WINSVSHARD];
    self.hardWinsLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    totalNumWins += tempInt;
    hardGamesPlayed += tempInt;
    hardNumWins += tempInt;
    totalWin += tempInt;
    
    tempInt = [defaults integerForKey:TIEONLINE];
    self.onlineTieLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    onlineGamesPlayed += tempInt;
    totalTie += tempInt;
    
    tempInt = [defaults integerForKey:TIEVSEASY];
    self.easyTieLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    easyGamesPlayed += tempInt;
    totalTie += tempInt;
    
    tempInt = [defaults integerForKey:TIEVSMEDIUM];
    self.mediumTieLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    mediumGamesPlayed += tempInt;
    totalTie += tempInt;
    
    tempInt = [defaults integerForKey:TIEVSHARD];
    self.hardTieLbl.text = [NSString stringWithFormat:@"%i", tempInt];
    totalGamesPlayed += tempInt;
    hardGamesPlayed += tempInt;
    totalTie += tempInt;
    
    // Total WINS
    self.totalWins.text = [NSString stringWithFormat:@"%.f", totalWin];
    // Total LOSSES
    self.totalLosses.text = [NSString stringWithFormat:@"%.f", totalLoss];
    // Total TIES
    self.totalTiesLbl.text = [NSString stringWithFormat:@"%.f", totalTie];
    // Games Played TOTAL
    self.totalGamesLbl.text = [NSString stringWithFormat:@"%.f", totalGamesPlayed];
    // Games Played Online
    self.onlineGamesPlayedLbl.text = [NSString stringWithFormat:@"%.f", onlineGamesPlayed];
    // Games Played EASY
    self.easyGamesPlayedLbl.text = [NSString stringWithFormat:@"%.f", easyGamesPlayed];
    // Games Played MEDIUM
    self.mediumGamesPlayedLbl.text = [NSString stringWithFormat:@"%.f", mediumGamesPlayed];
    // Games Played HARD
    self.hardGamesPlayedLbl.text = [NSString stringWithFormat:@"%.f", hardGamesPlayed];
    // Win Ratio TOTAL
    if (totalGamesPlayed == 0)
    {
        totalWinRatio = 0;
        
    }else
    {
        totalWinRatio = (totalNumWins / totalGamesPlayed) * 100;
    }
    self.totalWinRatioLbl.text = [NSString stringWithFormat:@"%.f%%", totalWinRatio];
    
    // Win Ratio Online
    if (onlineGamesPlayed == 0)
    {
        winRatioOnline = 0;
        
    }else
    {
        winRatioOnline = (onlineNumWins / onlineGamesPlayed) * 100;
    }
    self.winRatioOnlineLbl.text = [NSString stringWithFormat:@"%.f%%", winRatioOnline];
    
    // Win Ratio EASY
    if (easyGamesPlayed == 0)
    {
        winRatioEasy = 0;
        
    }else
    {
        winRatioEasy = (easyNumWins / easyGamesPlayed) * 100;
    }
    self.winRatioEasyLbl.text = [NSString stringWithFormat:@"%.f%%", winRatioEasy];
    
    // Win Ratio MEDIUM
    if (mediumGamesPlayed == 0)
    {
        winRatioMedium = 0;
    }
    else
    {
        winRatioMedium = (mediumNumWins / mediumGamesPlayed) * 100;
    }
    self.winRatioMediumLbl.text = [NSString stringWithFormat:@"%.f%%", winRatioMedium];
    
    // Win Ratio HARD
    if (hardGamesPlayed == 0)
    {
        winRatioHard = 0;
        
    }else
    {
        winRatioHard = (hardNumWins / hardGamesPlayed) * 100;
    }
    self.winRatioHardLbl.text = [NSString stringWithFormat:@"%.f%%", winRatioHard];
    
    // Consecutive wins
    self.consWinEasyLbl.text = [NSString stringWithFormat:@"%i", [defaults integerForKey:CONS_WIN_EASY]];
    self.consWinMedLbl.text = [NSString stringWithFormat:@"%i", [defaults integerForKey:CONS_WIN_MED]];
    self.consWinHardLbl.text = [NSString stringWithFormat:@"%i", [defaults integerForKey:CONS_WIN_HARD]];
    self.consWinOnlineLbl.text = [NSString stringWithFormat:@"%i", [defaults integerForKey:CONS_WIN_ONLINE]];
    self.consWinTotalLbl.text = [NSString stringWithFormat:@"%i", [defaults integerForKey:CONS_WIN_TOTAL]];
}

-(void)setAllBadgesToDisabled
{
    
}

- (IBAction)BackTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftBtnTUI:(id)sender
{
    CGPoint offset = self.achievementScrollView.contentOffset;
    offset.x -= 300;
    
    int pageNum = offset.x / 300;
    offset.x = (pageNum * 301);
    
    //[UIView animateWithDuration:0.3 animations:^{
    
    
    [self.achievementScrollView setContentOffset:offset animated:YES];
    //}];
}

- (IBAction)rightBtnTUI:(id)sender
{
    CGPoint offset = self.achievementScrollView.contentOffset;
    offset.x += 301;
    
    int pageNum = offset.x / 300;
    int offsetX = offset.x;
    
    if(offsetX % 301 != 0) pageNum++;

    offset.x = (pageNum * 301);
    
    if(offset.x < self.achievementScrollView.contentSize.width)
        [self.achievementScrollView setContentOffset:offset animated:YES];
}

- (IBAction)resetTUI:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                    message:@"Are you sure you want to reset all stats?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINFIVEEASY];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINFIVEMED];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINFIVEHARD];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINFIVEONLINE];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINTENEASY];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINTENMED];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINTENHARD];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WINTENONLINE];
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:WINSVSEASY];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:WINSVSMEDIUM];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:WINSVSHARD];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:WINSONLINE];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LOSSVSEASY];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LOSSVSMEDIUM];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LOSSVSHARD];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LOSSONLINE];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TIEVSEASY];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TIEVSMEDIUM];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TIEVSHARD];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TIEONLINE];
        [self SetStats];
    }
}

@end
