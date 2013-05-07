//
//  BADSettingsViewController.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADSettingsViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *xPlayerTxtField;

@property (weak, nonatomic) IBOutlet UITextField *oPlayerTxtField;
@property (weak, nonatomic) IBOutlet UILabel *onlineWins;
@property (weak, nonatomic) IBOutlet UILabel *onlineLosses;
@property (weak, nonatomic) IBOutlet UILabel *onlineFastestTime;
@property (weak, nonatomic) IBOutlet UILabel *winsVsEasy;
@property (weak, nonatomic) IBOutlet UILabel *winsVsHard;
@property (weak, nonatomic) IBOutlet UILabel *winsVsMedium;

- (IBAction)saveSettingsBtn:(id)sender;
- (IBAction)backBtnTUI:(id)sender;
- (IBAction)hasChrome:(id)sender;
- (IBAction)hasGold:(id)sender;
- (IBAction)hasBling:(id)sender;



@end
