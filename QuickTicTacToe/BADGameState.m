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
    [aCoder encodeObject:self.boardState forKey:@"BoardState"];
    [aCoder encodeInt:self.playersTurn forKey:@"PlayersTurn"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.boardState = [aDecoder decodeObjectForKey:@"BoardState"];
    self.playersTurn = [aDecoder decodeIntForKey:@"PlayersTurn"];
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.boardState = [[NSMutableArray alloc] initWithCapacity:9];
        self.playersTurn = TTxPlayerTurn;
    }
    return self;
}

@end
