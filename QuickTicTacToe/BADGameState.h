//
//  BADGameState.h
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TTxPlayerTurn = 1,
    TToPlayerTurn = 2
}TTPlayerTurn;

@interface BADGameState : NSObject <NSCoding>


@property TTPlayerTurn playersTurn;
@property (strong, nonatomic) NSMutableArray *boardState;

@end

