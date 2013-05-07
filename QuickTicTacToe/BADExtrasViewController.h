//
//  BADExtrasViewController.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface BADExtrasViewController : GAITrackedViewController<UIScrollViewDelegate>

- (IBAction)BackTUI:(id)sender;
- (IBAction)leftBtnTUI:(id)sender;
- (IBAction)rightBtnTUI:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *achievementScrollView;
@property (strong, nonatomic) NSMutableArray *tableViewData;
@property (weak, nonatomic) IBOutlet UILabel *achievementDesc;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *totalGamesLbl;


@property (weak, nonatomic) IBOutlet UILabel *onlineWinsLbl;
@property (weak, nonatomic) IBOutlet UILabel *easyWinsLbl;
@property (weak, nonatomic) IBOutlet UILabel *mediumWinsLbl;
@property (weak, nonatomic) IBOutlet UILabel *hardWinsLbl;
@property (weak, nonatomic) IBOutlet UILabel *onlineLossLbl;
@property (weak, nonatomic) IBOutlet UILabel *easyLossLbl;
@property (weak, nonatomic) IBOutlet UILabel *mediumLossLbl;
@property (weak, nonatomic) IBOutlet UILabel *hardLossLbl;
@property (weak, nonatomic) IBOutlet UILabel *onlineTieLbl;
@property (weak, nonatomic) IBOutlet UILabel *easyTieLbl;
@property (weak, nonatomic) IBOutlet UILabel *mediumTieLbl;
@property (weak, nonatomic) IBOutlet UILabel *hardTieLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalWinRatioLbl;
@property (weak, nonatomic) IBOutlet UILabel *onlineGamesPlayedLbl;
@property (weak, nonatomic) IBOutlet UILabel *easyGamesPlayedLbl;
@property (weak, nonatomic) IBOutlet UILabel *mediumGamesPlayedLbl;
@property (weak, nonatomic) IBOutlet UILabel *hardGamesPlayedLbl;
@property (weak, nonatomic) IBOutlet UILabel *winRatioOnlineLbl;
@property (weak, nonatomic) IBOutlet UILabel *winRatioEasyLbl;
@property (weak, nonatomic) IBOutlet UILabel *winRatioMediumLbl;
@property (weak, nonatomic) IBOutlet UILabel *winRatioHardLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalWins;
@property (weak, nonatomic) IBOutlet UILabel *totalLosses;
@property (weak, nonatomic) IBOutlet UILabel *totalTiesLbl;
@property (weak, nonatomic) IBOutlet UILabel *consWinOnlineLbl;
@property (weak, nonatomic) IBOutlet UILabel *consWinEasyLbl;
@property (weak, nonatomic) IBOutlet UILabel *consWinMedLbl;
@property (weak, nonatomic) IBOutlet UILabel *consWinHardLbl;
@property (weak, nonatomic) IBOutlet UILabel *consWinTotalLbl;

- (IBAction)resetTUI:(id)sender;

@end
