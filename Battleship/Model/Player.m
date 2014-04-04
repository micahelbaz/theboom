//
//  Player.m
//  Battleship
//
//  Created by Micah Elbaz on 3/5/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype) initWith: (NSString*) playerID andIsHost:(BOOL)player {
    self = [super init];
    if (self) {
        _playerID = playerID;
        _isHost = player;
        self.radarGrid = [[NSMutableArray alloc] init];
        self.dockingCoordinates = [[NSMutableArray alloc]init];
        self.baseCoordinates = [[NSMutableArray alloc]init];
        if(_isHost){
            for(int i = 10; i<20; i++){
                Coordinate *c = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:0 initiallyFacing:NONE];
                [self.baseCoordinates addObject:c];
                Coordinate *coord = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:1 initiallyFacing:NONE];
                [self.dockingCoordinates addObject:coord];
            }
            Coordinate *leftOfBase = [[Coordinate alloc] initWithXCoordinate:9 YCoordinate:0 initiallyFacing:NONE];
            Coordinate *rightOfBase = [[Coordinate alloc] initWithXCoordinate:9 YCoordinate:0 initiallyFacing:NONE];
            [self.dockingCoordinates addObject:leftOfBase];
            [self.dockingCoordinates addObject:rightOfBase];
        }
        else{
            for(int i = 10; i<20; i++){
                Coordinate *c = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:29 initiallyFacing:NONE];
                [self.baseCoordinates addObject:c];
            }
        }
        
        

    }
    self.playerFleet = [[Fleet alloc] initWith:_isHost];
    self.enemyFleet = [[Fleet alloc] initWith:!_isHost];
    return self;
}

-(void) updateRadarRange {
    for(int i = 0; i<GRID_SIZE; i++){
        self.radarGrid[i] = [[NSMutableArray alloc] init];
        for(int j = 0; j < GRID_SIZE; j++){
            [self.radarGrid[i] insertObject:[NSNumber numberWithBool:NO] atIndex:j];
        }
    }
    for (Ship *s in self.playerFleet.shipArray) {
        for (Coordinate *c in s.visibleCoordinates) {
            [self.radarGrid[c.xCoord] removeObjectAtIndex:c.yCoord];
            [self.radarGrid[c.xCoord] insertObject:[NSNumber numberWithBool:YES] atIndex:c.yCoord];
            NSLog(@"updateRadarRange: x: %d, y: %d", c.xCoord, c.yCoord);
        }
    }
}
@end
