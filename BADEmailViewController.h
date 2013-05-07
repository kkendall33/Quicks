//
//  BADEmailViewController.h
//  QuickTicTacToe
//
//  Created by Jacob Smith on 2/26/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BADEmailViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)backBtnTUI:(id)sender;
- (IBAction)Contact:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)Share:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *soundSetting;
- (IBAction)switchTUI:(id)sender;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
- (IBAction)rateTUI:(id)sender;
- (IBAction)shareTD:(id)sender;

@end
