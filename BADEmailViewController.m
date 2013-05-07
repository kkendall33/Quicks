//
//  BADEmailViewController.m
//  QuickTicTacToe
//
//  Created by Jacob Smith on 2/26/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADEmailViewController.h"
#import "BADAppDelegate.h"
#import "BADConstants.h"

@interface BADEmailViewController ()

@end

@implementation BADEmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
    {
        self.soundSetting.on = YES;
    }
    else
    {
        self.soundSetting.on = NO;
    }
}

- (IBAction)Contact:(id)sender {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        
        if ([mailClass canSendMail]) {
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            NSString *email = @"jacobblaine.smith@gmail.com";
            NSArray *emailArray = [[NSArray alloc] initWithObjects:email, nil];
            [picker setToRecipients:emailArray];
            [picker setSubject:@"Support Question"];
            NSString *emailBody = @"\n\n\n\n//Please share any comments, suggestions, and/or questions.\n\nFrom your friends,\nQuick-Tac Toe";
            [picker setMessageBody:emailBody isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Email" message:@"This device is not yet configured for sending emails." delegate:self cancelButtonTitle:@"Okay, I'll Try Later" otherButtonTitles:nil];
            [alertView show];
        }
    }

}

- (IBAction)facebook:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/quicktactoeapp"]];
}

- (IBAction)Share:(id)sender {
    NSString *message = @"Check out this new app - Quick-Tac Toe at...";
    
    NSArray *postItems = @[message];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *resultTitle = nil;
    NSString *resultMsg = nil;
    
    switch (result) {
            
        case MFMailComposeResultCancelled:
            resultTitle = @"Email Cancelled";
            resultMsg = @"Your email was cancelled";
            break;
            
        case MFMailComposeResultSaved:
            resultTitle = @"Email Saved";
            resultMsg = @"Your email was saved as a draft";
            break;
            
        case MFMailComposeResultSent:
            resultTitle = @"Email Sent";
            resultMsg = @"Your email was successfully delivered";
            break;
            
        case MFMailComposeResultFailed:
            resultTitle = @"Email Failed";
            resultMsg = @"Sorry, an error occurred.  You email could not be send";
            break;
            
        default:
            break;
            
    }
    
    UIAlertView *mailAlertView = [[UIAlertView alloc] initWithTitle:resultTitle message:resultMsg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [mailAlertView show];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backBtnTUI:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchTUI:(id)sender
{
    BADAppDelegate *app =(BADAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.soundSetting.on)
    {
        [app.backgroundMusicPlayer play];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUNDON];
    }
    else
    {
        [app.backgroundMusicPlayer stop];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SOUNDON];
    }
}

- (IBAction)rateTUI:(id)sender
{
    NSString *appId = @"542254383";
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:APP_ALREADY_RATED];
}

- (IBAction)shareTD:(id)sender
{
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Click2-Sebastian-759472264.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [self.backgroundMusicPlayer setDelegate:self];
    [self.backgroundMusicPlayer setNumberOfLoops:1];
    
    self.backgroundMusicPlayer.volume = .9;
    
    [self.backgroundMusicPlayer prepareToPlay];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON]==YES)
    {
        [self.backgroundMusicPlayer play];
    }
}

@end
