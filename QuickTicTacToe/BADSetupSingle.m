//
//  BADSetupSingle.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/31/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADSetupSingle.h"
#import "BADConstants.h"

@interface BADSetupSingle ()

@end

@implementation BADSetupSingle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserDefaults) name:@"setupBtn" object:nil];
    }
    return self;
}

-(void)setUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setValue:self.oPlayerTxtFld.text forKey:OPLAYERTAG];
    [[NSUserDefaults standardUserDefaults] setValue:self.xPlayerTxtFld.text forKey:XPLAYERTAG];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.oPlayerTxtFld.delegate = self;
    self.xPlayerTxtFld.delegate = self;
    
    self.xPlayerTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:XPLAYERTAG];
//    
//    NSString *xPlayerName = [[NSUserDefaults standardUserDefaults] valueForKey:XPLAYERTAG];
//    NSString *oPlayerName = [[NSUserDefaults standardUserDefaults] valueForKey:OPLAYERTAG];
    
//    self.oPlayerTxtFld.text = oPlayerName;
//    self.xPlayerTxtFld.text = xPlayerName;
    
    self.chromeBtn.enabled = [[NSUserDefaults standardUserDefaults] boolForKey:HASCHROME];
    self.goldBtn.enabled = [[NSUserDefaults standardUserDefaults] boolForKey:HASGOLD];
    self.blingBtn.enabled = [[NSUserDefaults standardUserDefaults] boolForKey:HASBLING];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)middleBtnTUI:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupBtn" object:nil];
}

- (IBAction)difficultyTUI:(UIButton *)sender
{
    NSString *setting = sender.titleLabel.text;
    sender.selected = YES;
    [[NSUserDefaults standardUserDefaults] setObject:setting forKey:DIFFICULTY];
}

- (IBAction)blingTUI:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"BlingX.png" forKey:XIMAGES];
    [[NSUserDefaults standardUserDefaults] setObject:@"BlingO.png" forKey:OIMAGES];
    self.blingBtn.selected = YES;
    self.chromeBtn.selected = NO;
    self.goldBtn.selected = NO;
}

- (IBAction)easyTUI:(id)sender
{
    NSString *setting = self.easyBtn.titleLabel.text;
    self.easyBtn.selected = YES;
    self.mediumBtn.selected = NO;
    self.hardBtn.selected = NO;
    [[NSUserDefaults standardUserDefaults] setObject:setting forKey:DIFFICULTY];
}

- (IBAction)hardTUI:(id)sender
{
    NSString *setting = self.hardBtn.titleLabel.text;
    self.easyBtn.selected = NO;
    self.mediumBtn.selected = NO;
    self.hardBtn.selected = YES;
    [[NSUserDefaults standardUserDefaults] setObject:setting forKey:DIFFICULTY];
}

- (IBAction)goldTUI:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"GoldX.png" forKey:XIMAGES];
    [[NSUserDefaults standardUserDefaults] setObject:@"GoldO.png" forKey:OIMAGES];
    self.goldBtn.selected = YES;
    self.chromeBtn.selected = NO;
    self.blingBtn.selected = NO;
}

-(void)chromeTUI:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ChromeX.png" forKey:XIMAGES];
    [[NSUserDefaults standardUserDefaults] setObject:@"ChromeO.png" forKey:OIMAGES];
    self.chromeBtn.selected = YES;
    self.goldBtn.selected = NO;
    self.blingBtn.selected = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backBtnTUI:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BACKBTN object:nil];
}

- (IBAction)startTUI:(id)sender
{
//    [UIView animateWithDuration:0.5
//                          delay:0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         [self.view setFrame:CGRectMake(-360, 0, 10, 10)];
//                         //here you may add any othe actions, but notice, that ALL of them will do in SINGLE step. so, we setting ONLY xx coordinate to move it horizantly first.
//                     }
//                     completion:^(BOOL finished){
//                         
//                         //here any actions, thet must be done AFTER 1st animation is finished. If you whant to loop animations, call your function here.
//                         self.view = nil;
//                     }];
}

- (IBAction)mediumTUI:(id)sender
{
    NSString *setting = self.mediumBtn.titleLabel.text;
    self.easyBtn.selected = NO;
    self.mediumBtn.selected = YES;
    self.hardBtn.selected = NO;
    [[NSUserDefaults standardUserDefaults] setObject:setting forKey:DIFFICULTY];
}

@end
