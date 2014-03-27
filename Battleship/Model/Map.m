//
//  Map.m
//  Battleship
//
//  Created by Robert Schneidman on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Map.h"

@interface Map()

-(void) initializeBase:(NSString*) player;

@end

@implementation Map

- (instancetype) init {
    self = [super init];
    if (self) {
        self.grid = [[NSMutableArray alloc] init];
        //if ([[GCHelper sharedInstance:nil] localPlayer].playerID == )
        for(int i = 0; i<GRID_SIZE; i++){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [self.grid insertObject:array atIndex:i ];
            for(int j = 0; j < GRID_SIZE; j++){
                Terrain t = WATER;
                [self.grid[i] insertObject:[NSNumber numberWithInt:t] atIndex:j];
            }
        }
        [self initializeBase:@"host"];
        
        [self initializeBase:@"join"];
        [self initializeCoral];
    }
    
    return self;
}


-(void) encodeWithCoder: (NSCoder*) coder {
    [coder encodeObject:_grid forKey:@"myArray"];
}

-(id) initWithCoder:(NSCoder *)coder {
    id mapID = [coder decodeObjectForKey:@"myArray"];
    return mapID;
}

-(void) initializeBase:(NSString*) player {
    int i;
    Terrain t;
    if ([player isEqualToString:@"host"]) {
        i = 0;
        t = HOST_BASE;
    }
    if ([player isEqualToString:@"join"]) {
        i = GRID_SIZE - 1;
        t = JOIN_BASE;
    }
    for(int j = BASE_START; j < BASE_START + BASE_LENGTH; j++) {
        [_grid[j] removeObjectAtIndex:i];
        [_grid[j] insertObject:[NSNumber numberWithInt:t] atIndex:i];
    }
}

-(void) initializeCoral {
    NSMutableSet *coralPositions = [[NSMutableSet alloc] init];
    while ([coralPositions count] < 24)    {
        int yCoord = 10 + arc4random_uniform(10);
        int xCoord = 3 + arc4random_uniform(24);
        int breakFlag = 0;
        Coordinate *c = [[Coordinate alloc]initWithXCoordinate:xCoord YCoordinate:yCoord initiallyFacing:NONE];
        for (Coordinate *contained in coralPositions) {
            if (contained.xCoord == c.xCoord && contained.yCoord == c.yCoord) {
                breakFlag = 1;
                continue;
            }
        }
        if (breakFlag == 1) {
            continue;
        }
        [coralPositions addObject:c];
    }
    for (Coordinate *contained in coralPositions)
    {
        Terrain t = CORAL;
        [_grid[contained.xCoord] removeObjectAtIndex:contained.yCoord];
        [_grid[contained.xCoord] insertObject:[NSNumber numberWithInt:t] atIndex:contained.yCoord];
    }
}

-(void) setCoords:(NSMutableArray *) coords
               to:(Terrain) t {
    for (Coordinate* c in coords) {
        [_grid[c.xCoord] removeObjectAtIndex:c.yCoord];
        [_grid[c.xCoord] insertObject:[NSNumber numberWithInt:t] atIndex:c.yCoord];
    }
}

-(Coordinate*) collisionLocationOfTorpedo:(Coordinate *)firedFrom {
    Coordinate *c = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
    switch(firedFrom.direction) {
        case NORTH:
            for(int i = 1; i <= 10; i++) {
                c.xCoord = firedFrom.xCoord;
                c.yCoord = firedFrom.yCoord + i;
                if (i == 10) {
                    return c;
                }
                else if (![_grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    return c;
                }
                else if ([_grid[c.xCoord][c.yCoord] intValue] != WATER) {
                    return c;
                }
            }
            break;
        case SOUTH:
            for(int i = 1; i <= 10; i++) {
                c.xCoord = firedFrom.xCoord;
                c.yCoord = firedFrom.yCoord - i;
                if (i == 10) {
                    return c;
                }
                else if (![_grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    return c;
                }
                else if ([_grid[c.xCoord][c.yCoord] intValue] != WATER) {
                    return c;
                }
            }
            break;
        case WEST:
            for(int i = 1; i <= 10; i++) {
                c.xCoord = firedFrom.xCoord - i;
                c.yCoord = firedFrom.yCoord;
                if (i == 10) {
                    return c;
                }
                else if (![_grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    return c;
                }
                else if ([_grid[c.xCoord][c.yCoord] intValue] != WATER) {
                    return c;
                }
            }
            break;
        case EAST:
            for(int i = 1; i <= 10; i++) {
                c.xCoord = firedFrom.xCoord + i;
                c.yCoord = firedFrom.yCoord;
                if (i == 10) {
                    return c;
                }
                else if (![_grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    return c;
                }
                else if ([_grid[c.xCoord][c.yCoord] intValue] != WATER) {
                    return c;
                }
            }
            break;
        default:
            break;
    }
    return Nil;
}

@end
