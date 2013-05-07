//
//  BADAchievementNotifier.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 2/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADAchievementNotifier.h"
#import "BADConstants.h"

#define TESTING NO

@implementation BADAchievementNotifier

-(void)setNotificationsObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNotification:)
                                                 name:CHECKFORACHIEVEMENT
                                               object:nil];
}

-(void)checkNotification:(NSNotification *)notification
{
    NSLog(@"checking Notifications");
    
    NSString *notifName = NULL;
    
    NSString *key = @"time";
    NSDictionary *dictionary = [notification userInfo];
    NSNumber *time = [dictionary valueForKey:key];
    int intTime = [time intValue];
    NSString *dif = [dictionary valueForKey:@"difficulty"];
    NSString *winLossTie = [dictionary valueForKey:@"winLossTie"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(TESTING)
    {
        notifName = @"Test Case";
    }
    
    NSInteger temp = 0;
    
    if([dif isEqualToString:@"Easy"])
    {
        if([winLossTie isEqualToString:@"win"])
        {
            temp = [defaults integerForKey:CONS_WIN_EASY];
            temp++;
            [defaults setInteger:temp forKey:CONS_WIN_EASY];
        }
        else
        {
            [defaults setInteger:0 forKey:CONS_WIN_EASY];
        }
    }
    
    if([dif isEqualToString:@"Medium"])
    {
        if([winLossTie isEqualToString:@"win"])
        {
            temp = [defaults integerForKey:CONS_WIN_MED];
            temp++;
            [defaults setInteger:temp forKey:CONS_WIN_MED];
        }
        else
        {
            [defaults setInteger:0 forKey:CONS_WIN_MED];
        }
    }
    
    if([dif isEqualToString:@"Hard"])
    {
        if([winLossTie isEqualToString:@"win"])
        {
            temp = [defaults integerForKey:CONS_WIN_HARD];
            temp++;
            [defaults setInteger:temp forKey:CONS_WIN_HARD];
        }
        else
        {
            [defaults setInteger:0 forKey:CONS_WIN_HARD];
        }
    }
    
    if([dif isEqualToString:@"Online"])
    {
        if([winLossTie isEqualToString:@"win"])
        {
            temp = [defaults integerForKey:CONS_WIN_ONLINE];
            temp++;
            [defaults setInteger:temp forKey:CONS_WIN_ONLINE];
        }
        else
        {
            [defaults setInteger:0 forKey:CONS_WIN_ONLINE];
        }
    }
    
    NSInteger highest = [defaults integerForKey:CONS_WIN_TOTAL];
    temp = [defaults integerForKey:CONS_WIN_EASY];
    if(highest < temp)
    {
        highest = temp;
    }
    
    temp = [defaults integerForKey:CONS_WIN_MED];
    if(highest < temp)
    {
        highest = temp;
    }
    
    temp = [defaults integerForKey:CONS_WIN_HARD];
    if(highest < temp)
    {
        highest = temp;
    }
    
    temp = [defaults integerForKey:CONS_WIN_ONLINE];
    if(highest < temp)
    {
        highest = temp;
    }
    
    [defaults setInteger:highest forKey:CONS_WIN_TOTAL];
    
//    if([dif isEqualToString:@"online"])
//    {
//        
//    }
    
    if([winLossTie isEqualToString:@"win"])
    {
        if([defaults integerForKey:WINSVSEASY] == 5 && ![defaults boolForKey:WINFIVEEASY])
        {
            notifName = @"Win 5 Easy";
            [defaults setBool:YES forKey:WINFIVEEASY];
        }
        
        if([defaults integerForKey:WINSVSEASY] == 10 && ![defaults boolForKey:WINTENEASY])
        {
            notifName = @"Win 10 Easy";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINTENEASY];
        }
        
        if([defaults integerForKey:WINSVSEASY] == 25 && ![defaults boolForKey:WIN25EASY])
        {
            notifName = @"Win 25 Easy";
            [defaults setBool:YES forKey:WIN25EASY];
        }
        
        if([defaults integerForKey:WINSVSEASY] == 100 && ![defaults boolForKey:WIN100EASY])
        {
            notifName = @"Win 100 Easy";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WIN100EASY];
        }
        
        if([defaults integerForKey:WINSVSMEDIUM] == 5 && ![defaults boolForKey:WINFIVEMED])
        {
            notifName = @"Win 5 Medium";
            [defaults setBool:YES forKey:WINFIVEMED];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSMEDIUM] == 10 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINTENMED])
        {
            notifName = @"Win 10 Medium";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINTENMED];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSMEDIUM] == 25 && ![[NSUserDefaults standardUserDefaults] boolForKey:WIN25MED])
        {
            notifName = @"Win 25 Medium";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WIN25MED];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSMEDIUM] == 100 && ![[NSUserDefaults standardUserDefaults] boolForKey:WIN100MED])
        {
            notifName = @"Win 100 Medium";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WIN100MED];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD] == 5 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINFIVEHARD])
        {
            notifName = @"Win 5 Hard";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINFIVEHARD];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD] == 10 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINTENHARD])
        {
            notifName = @"Win 10 Hard";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINTENHARD];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD] == 25 && ![[NSUserDefaults standardUserDefaults] boolForKey:WIN25HARD])
        {
            notifName = @"Win 25 Hard";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WIN25HARD];
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:WINSVSHARD] == 100 && ![[NSUserDefaults standardUserDefaults] boolForKey:WIN100HARD])
        {
            notifName = @"Win 100 Hard";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WIN100HARD];
        }
        
//        if(intTime < 10 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10EASY] && [dif isEqualToString:@"Easy"])
//        {
//            notifName = @"Under 10 Easy";
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER10EASY];
//        }
//        
//        if(intTime < 10 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10MED] && [dif isEqualToString:@"Medium"])
//        {
//            notifName = @"Under 10 Medium";
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER10MED];
//        }
//        
//        if(intTime < 10 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10HARD] && [dif isEqualToString:@"Hard"])
//        {
//            notifName = @"Under 10 Hard";
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER10HARD];
//        }
//        
//        if(intTime < 10 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER10ONLINE] && [dif isEqualToString:@"difficulty"])
//        {
//            notifName = @"Under 10 Online";
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER10ONLINE];
//        }
        
        if(intTime < 5 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5EASY] && [dif isEqualToString:@"Easy"])
        {
            notifName = @"Under 5 Easy";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER5EASY];
        }
        
        if(intTime < 5 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5MED] && [dif isEqualToString:@"Medium"])
        {
            notifName = @"Under 5 Medium";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER5MED];
        }
        
        if(intTime < 5 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5HARD] && [dif isEqualToString:@"Hard"])
        {
            notifName = @"Under 5 Hard";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER5HARD];
        }
        
        if(intTime < 5 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER5ONLINE] && [dif isEqualToString:@"difficulty"])
        {
            notifName = @"Under 5 Online";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER5ONLINE];
        }
        
        if(intTime < 2 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2EASY] && [dif isEqualToString:@"Easy"])
        {
            notifName = @"Under 2 Easy";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER2EASY];
        }
        
        if(intTime < 2 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2MED] && [dif isEqualToString:@"Medium"])
        {
            notifName = @"Under 2 Medium";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER2MED];
        }
        
        if(intTime < 2 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2HARD] && [dif isEqualToString:@"Hard"])
        {
            notifName = @"Under 2 Hard";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER2HARD];
        }
        
        if(intTime < 2 && ![[NSUserDefaults standardUserDefaults] boolForKey:WINUNDER2ONLINE] && [dif isEqualToString:@"difficulty"])
        {
            notifName = @"Under 2 Online";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WINUNDER2ONLINE];
        }
        
        if(intTime < 1 && ![defaults boolForKey:WINUNDER1EASY] && [dif isEqualToString:@"Easy"])
        {
            notifName = @"Under 1 Easy";
            [defaults setBool:YES forKey:WINUNDER1EASY];
        }
        
        if(intTime < 1 && ![defaults boolForKey:WINUNDER1MED] && [dif isEqualToString:@"Medium"])
        {
            notifName = @"Under 1 Medium";
            [defaults setBool:YES forKey:WINUNDER1MED];
        }
        
        if(intTime < 1 && ![defaults boolForKey:WINUNDER1HARD] && [dif isEqualToString:@"Hard"])
        {
            notifName = @"Under 1 Hard";
            [defaults setBool:YES forKey:WINUNDER1HARD];
        }
        
        if(intTime < 1 && ![defaults boolForKey:WINUNDER1ONLINE] && [dif isEqualToString:@"difficulty"])
        {
            notifName = @"Under 1 Online";
            [defaults setBool:YES forKey:WINUNDER1ONLINE];
        }
        
        if([defaults integerForKey:CONS_WIN_EASY] >= 5 && [dif isEqualToString:@"Easy"])
        {
            notifName = @"Win 5 in-a-row Easy";
            [defaults setBool:YES forKey:WIN5CONSEASY];
        }
        
        if([defaults integerForKey:CONS_WIN_MED] >= 5 && [dif isEqualToString:@"Medium"])
        {
            notifName = @"Win 5 in-a-row Medium";
            [defaults setBool:YES forKey:WIN5CONSMED];
        }
        
        if([defaults integerForKey:CONS_WIN_HARD] >= 5 && [dif isEqualToString:@"Hard"])
        {
            notifName = @"Win 5 in-a-row Hard";
            [defaults setBool:YES forKey:WIN5CONSHARD];
        }
        
        if([defaults integerForKey:CONS_WIN_ONLINE] >= 5 && [dif isEqualToString:@"Online"])
        {
            notifName = @"Win 5 in-a-row Online";
            [defaults setBool:YES forKey:WIN5CONSONLINE];
        }
    }
    
    if(notifName != NULL)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:notifName forKey:@"NotifName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ACHIEVEMENTEARNED object:nil userInfo:userInfo];
    }
}

@end
