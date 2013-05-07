//
//  BADSetupSingle.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/31/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADSetupSingle : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *chromeBtn;
@property (weak, nonatomic) IBOutlet UIButton *goldBtn;
@property (weak, nonatomic) IBOutlet UIButton *blingBtn;
@property (weak, nonatomic) IBOutlet UITextField *oPlayerTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *xPlayerTxtFld;
@property (weak, nonatomic) IBOutlet UILabel *oPlayerTxt;
@property (weak, nonatomic) IBOutlet UIButton *easyBtn;
@property (weak, nonatomic) IBOutlet UIButton *mediumBtn;
@property (weak, nonatomic) IBOutlet UIButton *hardBtn;

- (IBAction)backBtnTUI:(id)sender;

- (IBAction)middleBtnTUI:(id)sender;
- (IBAction)chromeTUI:(id)sender;
- (IBAction)goldTUI:(id)sender;
- (IBAction)blingTUI:(id)sender;
- (IBAction)easyTUI:(id)sender;
- (IBAction)hardTUI:(id)sender;

- (IBAction)startTUI:(id)sender;
- (IBAction)mediumTUI:(id)sender;

@end
