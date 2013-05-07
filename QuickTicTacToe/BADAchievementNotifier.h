//
//  BADAchievementNotifier.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 2/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BADAchievementNotifier : NSObject

@property BOOL lastTimeWon;

-(void)setNotificationsObserving;

@end
