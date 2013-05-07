//
//  BADAppDelegate.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/5/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADAppDelegate.h"
#import "GAI.h"
#import "BADConstants.h"

#define daysTilRatePopup 10
#define fAlertView1 1

@implementation BADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.notifier = [[BADAchievementNotifier alloc] init];
    [self.notifier setNotificationsObserving];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-38646212-1"];
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Cry No More.mp3", [[NSBundle mainBundle] resourcePath]]];;
    NSError *error;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    [self.backgroundMusicPlayer setDelegate:self];
    [self.backgroundMusicPlayer setNumberOfLoops:-1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"firstRun"])
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.backgroundMusicPlayer.volume = 0.08;
    
    if(![defaults objectForKey:@"firstRun"])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUNDON];
    
    if (_otherMusicIsPlaying != 1 && !_backgroundMusicPlaying)
    {
        [self.backgroundMusicPlayer prepareToPlay];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON]==YES)
        {
            [self.backgroundMusicPlayer play];
            _backgroundMusicPlaying = YES;
        }
    }
    
    [self checkRateApp];
    
    return YES;
}

-(void)checkRateApp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastDate = [defaults objectForKey:DATE_LAST_SHOWN];
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:lastDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    int days = [difference day];
    
    BOOL appRated = [defaults boolForKey:APP_ALREADY_RATED];
    BOOL hasLaunched = [defaults boolForKey:HAS_LAUNCHED];
    if(!appRated && days >= daysTilRatePopup && hasLaunched){
        [defaults setObject:[NSDate date] forKey:DATE_LAST_SHOWN];
        
        UIAlertView *rateAppAlert = [[UIAlertView alloc] initWithTitle:@"Rate Quick-Tac Toe!"
                                                               message:@"Let us know if you like it!"
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Later", @"Rate", nil];
        
        rateAppAlert.tag = fAlertView1;
        [rateAppAlert show];
    }
    
    if(hasLaunched == NO) [defaults setBool:YES forKey:HAS_LAUNCHED];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == fAlertView1)
    {
        if(buttonIndex == 1)
        {
            NSString *appId = @"542254383";
            
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", appId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:APP_ALREADY_RATED];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
