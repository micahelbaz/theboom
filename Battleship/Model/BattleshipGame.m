//
//  BattleshipGame.m
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//
#import "BattleshipGame.h"
@interface BattleshipGame()
-(void)updateMap:(Fleet*) updatedFleet;
-(void)removeShipFromMap: (Ship*) s;
-(BOOL)sendMap;
-(void)match:(GKMatch*)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end
@implementation BattleshipGame

static BattleshipGame *sharedGame = nil;
+ (BattleshipGame *)sharedInstance {
    if(!sharedGame){
        sharedGame = [[BattleshipGame alloc] init];
    }
    return sharedGame;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _gameCenter = [GCHelper sharedInstance:nil];
        NSString* loc = [GKLocalPlayer localPlayer].playerID;
        if ([loc compare:_gameCenter.match.playerIDs[0]] < 0) {
            _localPlayer = [[Player alloc] initWith:[GKLocalPlayer localPlayer].playerID andIsHost:TRUE];
            _myTurn = true;
            _gameMap = [[Map alloc] init];
        }
        else {
            _localPlayer = [[Player alloc] initWith:[GKLocalPlayer localPlayer].playerID andIsHost:FALSE];
            _myTurn = false;
        }
        _gameMap = [[Map alloc] init];
        if (_myTurn) {
            
        }
    }
    return self;
}
//must remove fleet and then add fleet back
-(void)updateMap:(Fleet*) updatedFleet{
    for(Ship* ship in updatedFleet.shipArray) {
        NSLog(@"%@", ship.shipName);
        for(ShipSegment* seg in ship.blocks) {
            NSLog(@"%d, %d", seg.location.xCoord, seg.location.yCoord);
            [_gameMap.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
            [_gameMap.grid[seg.location.xCoord] insertObject:seg atIndex:seg.location.yCoord];
        }
    }
}
-(void)removeShipFromMap: (Ship*) s {
    for(ShipSegment* seg in s.blocks) {
        [_gameMap.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
        [_gameMap.grid[seg.location.xCoord] insertObject:[NSNumber numberWithInt:WATER] atIndex:seg.location.yCoord];
    }
}
-(void)moveShipfrom:(Coordinate *)origin to:(Coordinate *)destination {
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    [self removeShipFromMap: s];
    [s positionShip: destination isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
    [self updateMap:_localPlayer.playerFleet];
}
-(void)moveEnemyShipfrom:(Coordinate *)origin to:(Coordinate *)destination {
    Ship* s = [_localPlayer.enemyFleet getShipWithCoord:origin];
    [self removeShipFromMap: s];
    [s positionShip: destination isHost:FALSE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
    [self updateMap:_localPlayer.enemyFleet];
}
-(NSMutableArray*) getValidMovesFrom:(Coordinate*)origin withRadarPositions:(BOOL)radarPositions {
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    
    
    
    NSMutableArray *validMoves = [s getHeadLocationsOfMove];
    NSMutableArray *movesToBeRemoved = [[NSMutableArray alloc] init];
    for (NSMutableArray* move in validMoves) {
        for(Coordinate* segmentLocation in move) {
            if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[ShipSegment class]]) {
                ShipSegment *seg =_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord];
                if (![seg.shipName isEqualToString:s.shipName]) {
                    [movesToBeRemoved addObject:move];
                }
            }
            else if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[NSNumber class]]) {
                if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] intValue] != WATER) {
                    [movesToBeRemoved addObject: move];
                }
                
            }
        }
        
    }
    for (NSMutableArray* move in movesToBeRemoved) {
        [validMoves removeObject:move];
    }
    
    NSMutableArray *validSegmentLocations = [[NSMutableArray alloc] init];
    for (NSMutableArray* move in validMoves) {
        Coordinate *c = move[0];
        [validSegmentLocations addObject:c];
    }
    if (!radarPositions) {
        return validSegmentLocations;
    }
    else {
        NSMutableArray *segmentsWithinMoveRange = [[NSMutableArray alloc] init];
        for (Coordinate* headLocation in validSegmentLocations) {
            [segmentsWithinMoveRange addObject:headLocation];
            if (headLocation.direction == NORTH) {
                if (headLocation.xCoord+1 == s.location.xCoord || headLocation.xCoord-1 == s.location.xCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord;
                        segLocation.yCoord = headLocation.yCoord - i;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            else if (headLocation.direction == SOUTH) {
                if (headLocation.xCoord+1 == s.location.xCoord || headLocation.xCoord-1 == s.location.xCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord;
                        segLocation.yCoord = headLocation.yCoord + i;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            else if (headLocation.direction == WEST) {
                if (headLocation.yCoord+1 == s.location.yCoord || headLocation.yCoord-1 == s.location.yCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord + i;
                        segLocation.yCoord = headLocation.yCoord;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            else if (headLocation.direction == EAST) {
                if (headLocation.xCoord+1 == s.location.yCoord || headLocation.xCoord-1 == s.location.yCoord) {
                    for (int i = 1; i < s.size; i++) {
                        Coordinate* segLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
                        segLocation.xCoord = headLocation.xCoord;
                        segLocation.yCoord = headLocation.yCoord;
                        segLocation.direction = headLocation.direction;
                        [segmentsWithinMoveRange addObject:segLocation];
                    }
                }
            }
            
        }
        return segmentsWithinMoveRange;
    }
}
-(NSMutableArray *)getValidActionsFrom:(Coordinate *)origin {
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    
    return s.viableActions;
}
-(Coordinate*) fireTorpedo:(Coordinate *)origin {
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    Coordinate* impactCoord = [_gameMap collisionLocationOfTorpedo:s.location];
    if ([_gameMap.grid[impactCoord.xCoord][impactCoord.yCoord] isKindOfClass:[ShipSegment class]]) {
        ShipSegment *shipSeg = _gameMap.grid[impactCoord.xCoord][impactCoord.yCoord];
        int shipBlock = shipSeg.block;
        s = [_localPlayer.enemyFleet getShipWithCoord:impactCoord];
        [s damageShipWithTorpedoAt:shipBlock and:_localPlayer.playerFleet.dockingCoordinates];
    }
    return impactCoord;
}
-(Coordinate*) getCoordOfShip: (NSString*) shipName {
    Fleet *currentFleet;
    
    currentFleet = _localPlayer.playerFleet;
    
    for (Ship *s in currentFleet.shipArray) {
        if ([s.shipName isEqualToString:shipName]) {
            return s.location;
        }
    }
    return Nil;
}
-(NSMutableArray*) getShipDamages:(Coordinate *)origin {
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    
    NSMutableArray* damages = [[NSMutableArray alloc] init];
    for (int i = 0; i < s.size; i++) {
        ShipSegment *shipSeg = s.blocks[i];
        [damages addObject:[NSNumber numberWithInt:shipSeg.segmentArmourType]];
    }
    return damages;
}

-(NSMutableArray*) getCanonRange:(Coordinate*)origin{

    NSMutableArray * coords = [[NSMutableArray alloc]init];
    for(Ship *s in _localPlayer.playerFleet.shipArray){
        for(ShipSegment *seg in s.blocks){
            if(seg.location.xCoord == origin.xCoord && seg.location.yCoord == origin.yCoord){
                NSLog(@"test");
                return s.visibleCannonCoordinates;
            }
        }
    }
    return coords;
}
/*-(NSMutableArray *)getValidRotationsFrom:(Coordinate *)origin {
 Ship* s;
 if (_hostsTurn) {
 s = [_hostFleet getShipWithCoord:origin];
 }
 else {
 s = [_joinFleet getShipWithCoord:origin];
 }
 
 }*/
@end