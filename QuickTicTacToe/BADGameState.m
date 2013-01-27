//
//  BADGameState.m
//  QuickTicTacToe
//
//  Created by Kyle Kendall on 1/6/13.
//  Copyright (c) 2013 Kyle Kendall. All rights reserved.
//

#import "BADGameState.h"

@implementation BADGameState

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_boardState forKey:@"BoardState"];
    [aCoder encodeInt:_playersTurn forKey:@"PlayersTurn"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    _boardState = [aDecoder decodeObjectForKey:@"BoardState"];
    _playersTurn = [aDecoder decodeIntForKey:@"PlayersTurn"];
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _boardState = [[NSMutableArray alloc] initWithCapacity:9];
        _playersTurn = TTxPlayerTurn;
    }
    return self;
}

@end
