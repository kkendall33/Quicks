//
//  BADAppDelegate.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/5/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BADAchievementNotifier.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BADAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL _backgroundMusicPlaying;
    BOOL _backgroundMusicInterrupted;
    BOOL initialRun;
    UInt32 _otherMusicIsPlaying;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong) BADAchievementNotifier *notifier;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;

-(void)checkRateApp;

@end
