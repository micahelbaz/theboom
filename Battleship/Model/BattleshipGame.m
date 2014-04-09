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
        
        _mineImpactCoordinate = [[Coordinate alloc]init];
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
        
    }
    
    return self;
    
}

//must remove fleet and then add fleet back

-(void)updateMap:(Fleet*) updatedFleet{
    
    for(Ship* ship in updatedFleet.shipArray) {
        
        
        
        for(ShipSegment* seg in ship.blocks) {
            
            
            
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

-(Coordinate*)moveShipfrom:(Coordinate *)origin to:(Coordinate *)destination {
    
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    
    [self removeShipFromMap: s];
    if(destination.direction == NORTH){
        //Move Sideways
        if(origin.yCoord == destination.yCoord){
            for(int i =0; i<s.size; i++){
                if([_gameMap.grid[destination.xCoord][origin.yCoord-i] isKindOfClass:[NSNumber class]]){
                    Terrain terType = [_gameMap.grid[destination.xCoord][origin.yCoord-i] intValue];
                    if(terType == MINE){
                        _mineImpactCoordinate.xCoord = destination.xCoord;
                        _mineImpactCoordinate.yCoord = origin.yCoord-i;
                        destination = origin;
                        for(ShipSegment *seg in s.blocks){
                            if(seg.location.yCoord == origin.yCoord-i){
                                Coordinate *c = [[Coordinate alloc]init];
                                c.xCoord = origin.xCoord;
                                c.yCoord = origin.yCoord-i;
                                [s positionShip: c isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
                                [self updateMap:_localPlayer.playerFleet];
                                [self damageShipSegment:c ownedBy:TRUE with:TRUE and:TRUE];
                                [_gameMap.grid[destination.xCoord] removeObjectAtIndex:origin.yCoord-i];
                                [_gameMap.grid[destination.xCoord] insertObject:[NSNumber numberWithInt:WATER] atIndex:origin.yCoord-i];
                            }
                        }
                    }
                }
            }
        }
        //Move Backwards
        if(origin.yCoord>destination.yCoord){
            if([_gameMap.grid[destination.xCoord][destination.yCoord-s.size+1] isKindOfClass:[NSNumber class]]){
                Terrain terType = [_gameMap.grid[destination.xCoord][destination.yCoord-s.size+1] intValue];
                if(terType == MINE){
                    _mineImpactCoordinate.xCoord = destination.xCoord;
                    _mineImpactCoordinate.yCoord = destination.yCoord-s.size+1;
                    destination = origin;
                    ShipSegment *seg = s.blocks.lastObject;
                    Coordinate *c = [[Coordinate alloc]init];
                    c.yCoord = seg.location.yCoord;
                    c.xCoord = seg.location.xCoord;
                    [s positionShip: c isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
                    [self updateMap:_localPlayer.playerFleet];
                    [self damageShipSegment:c ownedBy:TRUE with:TRUE and:TRUE];
                   
                }
            }
        }
        //Move Forwards
        if(origin.yCoord<destination.yCoord){
            for(int i =origin.yCoord+1; i<=destination.yCoord; i++){
                if([_gameMap.grid[origin.xCoord][i] isKindOfClass:[NSNumber class]]){
                    Terrain terType = [_gameMap.grid[origin.xCoord][i] intValue];
                    if(terType == MINE){
                        _mineImpactCoordinate.xCoord = origin.xCoord;
                        _mineImpactCoordinate.yCoord = i;
                        destination.yCoord = i-1;
//                        for(ShipSegment *seg in s.blocks){
//                            if(seg.location.yCoord == i){
                                Coordinate *c = [[Coordinate alloc]init];
                                c.xCoord = origin.xCoord;
                                c.yCoord = i-1;
                                [s positionShip: c isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
                                [self updateMap:_localPlayer.playerFleet];
                                [self damageShipSegment:c ownedBy:TRUE with:TRUE and:TRUE];
                                NSLog(@"x:%d , y:%d", c.xCoord, c.yCoord);
                                for (int j = 0; j < 30; j++) {
                                    for (int k = 0; k < 30; k++) {
                                        if ([_gameMap.grid[j][k] isKindOfClass:[ShipSegment class]]) {
                                            ShipSegment *seggy = _gameMap.grid[j][k];
                                            NSLog(@"%@", seggy.shipName);
                                             NSLog(@"xCoord:%d , yCoord:%d", seggy.location.xCoord, seggy.location.yCoord);
                                        }
                                    }
                                }
                       
//                            }
//                        }
                    }
                }
            }
            
        }
    }
    else{
        //Move Sideways
        if(origin.yCoord == destination.yCoord){
            for(int i =0; i<s.size; i++){
                if([_gameMap.grid[destination.xCoord][origin.yCoord+i] isKindOfClass:[NSNumber class]]){
                    Terrain terType = [_gameMap.grid[destination.xCoord][origin.yCoord+i] intValue];
                    if(terType == MINE){
                        _mineImpactCoordinate.xCoord = destination.xCoord;
                        _mineImpactCoordinate.yCoord = origin.yCoord+i;
                        destination = origin;
                        for(ShipSegment *seg in s.blocks){
                            if(seg.location.yCoord == origin.yCoord+i){
                                Coordinate *c = [[Coordinate alloc]init];
                                c.xCoord = origin.xCoord;
                                c.yCoord = origin.yCoord+i;
                                [s positionShip: c isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
                                [self updateMap:_localPlayer.playerFleet];
                                [self damageShipSegment:c ownedBy:TRUE with:TRUE and:TRUE];
                            }
                        }
                    }
                }
            }
        }
        //Move Backwards
        if(origin.yCoord<destination.yCoord){
            if([_gameMap.grid[destination.xCoord][destination.yCoord+s.size-1] isKindOfClass:[NSNumber class]]){
                Terrain terType = [_gameMap.grid[destination.xCoord][destination.yCoord+s.size-1] intValue];
                if(terType == MINE){
                    _mineImpactCoordinate.xCoord = destination.xCoord;
                    _mineImpactCoordinate.yCoord = destination.yCoord+s.size-1;
                    destination = origin;
                    ShipSegment *seg = s.blocks.lastObject;
                    Coordinate *c = [[Coordinate alloc]init];
                    c.yCoord = seg.location.yCoord;
                    c.xCoord = seg.location.xCoord;
                    [s positionShip: c isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
                    [self updateMap:_localPlayer.playerFleet];
                    [self damageShipSegment:c ownedBy:TRUE with:TRUE and:TRUE];
                }
            }
        }
        //Move Forwards
        if(origin.yCoord>destination.yCoord){
            for(int i =origin.yCoord-1; i>=destination.yCoord; i--){
                if([_gameMap.grid[origin.xCoord][i] isKindOfClass:[NSNumber class]]){
                    Terrain terType = [_gameMap.grid[origin.xCoord][i] intValue];
                    if(terType == MINE){
                        _mineImpactCoordinate.xCoord = origin.xCoord;
                        _mineImpactCoordinate.yCoord = i;
                        destination.yCoord = i+1;
                        //                        for(ShipSegment *seg in s.blocks){
                        //                            if(seg.location.yCoord == i){
                        Coordinate *c = [[Coordinate alloc]init];
                        c.xCoord = origin.xCoord;
                        c.yCoord = i+1;
                        [s positionShip: c isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
                        [self updateMap:_localPlayer.playerFleet];
                        [self damageShipSegment:c ownedBy:TRUE with:TRUE and:TRUE];
                        NSLog(@"x:%d , y:%d", c.xCoord, c.yCoord);
                        for (int j = 0; j < 30; j++) {
                            for (int k = 0; k < 30; k++) {
                                if ([_gameMap.grid[j][k] isKindOfClass:[ShipSegment class]]) {
                                    ShipSegment *seggy = _gameMap.grid[j][k];
                                    NSLog(@"%@", seggy.shipName);
                                    NSLog(@"xCoord:%d , yCoord:%d", seggy.location.xCoord, seggy.location.yCoord);
                                }
                            }
                        }
                        //                            }
                        //                        }
                    }
                }
            }
        }
        
    }
    
    [s positionShip: destination isHost:TRUE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
    
    [self updateMap:_localPlayer.playerFleet];
    
    
    
    for(Ship* ship in _localPlayer.playerFleet.shipArray){
        
        if([ship isKindOfClass:[MineLayer class]]){
            
            [self isAbleToDropMine:(MineLayer*)ship];
            [self isAbleToPickupMine:(MineLayer*)ship];
            
        }
        
    }
    return destination;
}

-(void)moveEnemyShipfrom:(Coordinate *)origin to:(Coordinate *)destination {
    
    Ship* s = [_localPlayer.enemyFleet getShipWithCoord:origin];
    
    [self removeShipFromMap: s];
    
    [s positionShip: destination isHost:FALSE dockingArray:_localPlayer.playerFleet.dockingCoordinates];
    
    [self updateMap:_localPlayer.enemyFleet];
    
    for(Ship* ship in _localPlayer.playerFleet.shipArray){
        
        if([ship isKindOfClass:[MineLayer class]]){
            
            [self isAbleToDropMine:(MineLayer*)ship];
            [self isAbleToPickupMine:(MineLayer*)ship];
            
        }
        
    }
    
}

-(NSMutableArray*) getValidMovesFrom:(Coordinate*)origin withRadarPositions:(BOOL)radarPositions {
    
    Ship* s = [_localPlayer.playerFleet getShipWithCoord:origin];
    NSMutableArray *movesToBeRemoved = [[NSMutableArray alloc] init];
    
    
    
    NSMutableArray *validMoves = [[NSMutableArray alloc] init];
    if ([s isKindOfClass:[Kamikaze class]]) {
        Kamikaze *k = (Kamikaze*) s;
        validMoves = [k getMoveLocations];
        for(Coordinate *segmentLocation in validMoves) {
            if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[ShipSegment class]]) {
                
                ShipSegment *seg =_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord];
                
                if (![seg.shipName isEqualToString:s.shipName]) {
                    
                    [movesToBeRemoved addObject:segmentLocation];
                    
                }
                
            }
            
            else if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[NSNumber class]]) {
                
                if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] intValue] != WATER && [_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] intValue] != MINE) {
                    
                    [movesToBeRemoved addObject: segmentLocation];
                    
                }
                
                
                
            }
        }
        for (Coordinate *move in movesToBeRemoved) {
            [validMoves removeObject:move];
        }
        return validMoves;
    }
    else {
        validMoves = [s getHeadLocationsOfMove];
        for (NSMutableArray* move in validMoves) {
            
            for(Coordinate* segmentLocation in move) {
                
                if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[ShipSegment class]]) {
                    
                    ShipSegment *seg =_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord];
                    
                    if (![seg.shipName isEqualToString:s.shipName]) {
                        
                        [movesToBeRemoved addObject:move];
                        
                    }
                    
                }
                
                else if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] isKindOfClass:[NSNumber class]]) {
                    
                    if ([_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] intValue] != WATER && [_gameMap.grid[segmentLocation.xCoord][segmentLocation.yCoord] intValue] != MINE) {
                        
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
        
        [s damageShipWithTorpedoAt:shipBlock and:_localPlayer.playerFleet.dockingCoordinates with:FALSE];
        
    }
    
    return impactCoord;
    
}





-(void) damageShipSegment:(Coordinate*)impactCoord ownedBy:(BOOL) you with:(BOOL) heavyCannon and:(BOOL) adjacentSquare{
    
    Ship *s;
    if ([_gameMap.grid[impactCoord.xCoord][impactCoord.yCoord] isKindOfClass:[ShipSegment class]]) {
        ShipSegment *shipSeg = _gameMap.grid[impactCoord.xCoord][impactCoord.yCoord];
        NSLog(@"HELLOWORLD");
        int shipBlock = shipSeg.block;
        if (you) {
            s = [_localPlayer.playerFleet getShipWithCoord:impactCoord];
            
        }
        else {
            s = [_localPlayer.enemyFleet getShipWithCoord:impactCoord];
        }
        [s damageShipWithTorpedoAt:shipBlock and:_localPlayer.playerFleet.dockingCoordinates with:heavyCannon];
        if (adjacentSquare) {
            if (shipBlock != 0) {
                ShipSegment *adjacentSeg = s.blocks[shipBlock-1];
                if (adjacentSeg.segmentArmourType != DESTROYED) {
                    NSLog(@"damage next ship index part 1");
                    [s damageShipWithTorpedoAt:shipBlock-1 and:_localPlayer.playerFleet.dockingCoordinates with:heavyCannon];
                }
                else {
                    if (shipBlock != s.size-1) {
                        NSLog(@"damage next ship index part 2");
                        [s damageShipWithTorpedoAt:shipBlock+1 and:_localPlayer.playerFleet.dockingCoordinates with:heavyCannon];
                    }
                }
            }
            else if (shipBlock!= s.size-1){
                ShipSegment *adjacentSeg = s.blocks[shipBlock+1];
                if (adjacentSeg.segmentArmourType != DESTROYED) {
                    NSLog(@"damage next ship index part 1");
                    [s damageShipWithTorpedoAt:shipBlock+1 and:_localPlayer.playerFleet.dockingCoordinates with:heavyCannon];
                }
                
            }
        }
    }
    
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



-(int)getShipIndexWithName:(NSString*)shipName{
    
    int index = 0;
    
    for (Ship *s in self.localPlayer.playerFleet.shipArray) {
        
        //NSLog(@"%@", s.shipName);
        
        if ([shipName isEqualToString:s.shipName]) {
            
            //NSLog(@"%d", index);
            
            return index;
            
        }
        
        index++;
        
    }
    
    index = 0;
    
    
    
    return -1;
    
}





-(BOOL)isShipDestroyed:(NSString *)shipName {
    
    for(Ship *s in _localPlayer.playerFleet.shipArray){
        
        if ([s.shipName isEqualToString:shipName]) {
            
            if (s.isDestroyed) {
                
                NSLog(@"is destroyed");
                
                for (ShipSegment *seg in s.blocks) {
                    
                    [_gameMap.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
                    
                    [_gameMap.grid[seg.location.xCoord] insertObject:[NSNumber numberWithInt:WATER] atIndex:seg.location.yCoord];
                    
                }
                
            }
            
            return s.isDestroyed;
            
        }
        
    }
    
    for(Ship *s in _localPlayer.enemyFleet.shipArray){
        
        if ([s.shipName isEqualToString:shipName]) {
            
            if (s.isDestroyed) {
                
                NSLog(@"is destroyed");
                
                for (ShipSegment *seg in s.blocks) {
                    
                    [_gameMap.grid[seg.location.xCoord] removeObjectAtIndex:seg.location.yCoord];
                    
                    [_gameMap.grid[seg.location.xCoord] insertObject:[NSNumber numberWithInt:WATER] atIndex:seg.location.yCoord];
                    
                }
                
            }
            
            return s.isDestroyed;
            
        }
        
    }
    
    return FALSE;
    
}



-(void) isAbleToDropMine:(MineLayer *)mineLayer{
    [mineLayer.viableActions removeObject:@"DropMine"];
    if(mineLayer.location.direction == NORTH){
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = mineLayer.location.xCoord+1;
        rightOfShip1.yCoord = mineLayer.location.yCoord;
        rightOfShip2.xCoord = mineLayer.location.xCoord+1;
        rightOfShip2.yCoord = mineLayer.location.yCoord-1;
        leftOfShip1.xCoord = mineLayer.location.xCoord-1;
        leftOfShip1.yCoord = mineLayer.location.yCoord;
        leftOfShip2.xCoord = mineLayer.location.xCoord-1;
        leftOfShip2.yCoord = mineLayer.location.yCoord-1;
        aboveShip.yCoord = mineLayer.location.yCoord+1;
        aboveShip.xCoord = mineLayer.location.xCoord;
        belowShip.xCoord = mineLayer.location.xCoord;
        belowShip.yCoord = mineLayer.location.yCoord-2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        
        
        for(Coordinate *c in coordinates){
            if([c isWithinMap]){
                
                if ([_gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    
                    Terrain terType = [_gameMap.grid[c.xCoord][c.yCoord] intValue];
                    if(terType == WATER && mineLayer.numMines>0){
                        
                        
                        [mineLayer.viableActions addObject:@"DropMine"];
                        
                        goto endOfMethod;
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    else{
        
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = mineLayer.location.xCoord+1;
        rightOfShip1.yCoord = mineLayer.location.yCoord;
        rightOfShip2.xCoord = mineLayer.location.xCoord+1;
        rightOfShip2.yCoord = mineLayer.location.yCoord+1;
        leftOfShip1.xCoord = mineLayer.location.xCoord-1;
        leftOfShip1.yCoord = mineLayer.location.yCoord;
        leftOfShip2.xCoord = mineLayer.location.xCoord-1;
        leftOfShip2.yCoord = mineLayer.location.yCoord+1;
        aboveShip.yCoord = mineLayer.location.yCoord-1;
        aboveShip.xCoord = mineLayer.location.xCoord;
        belowShip.xCoord = mineLayer.location.xCoord;
        belowShip.yCoord = mineLayer.location.yCoord+2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        for(Coordinate *c in coordinates){
            
            if([c isWithinMap]){
                
                if ([_gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    
                    Terrain terType = [_gameMap.grid[c.xCoord][c.yCoord] intValue];
                    
                    if(terType == WATER && mineLayer.numMines>0){
                        
                        [mineLayer.viableActions addObject:@"DropMine"];
                        
                        goto endOfMethod;
                        
                    }
                    
                }
                
            }
            
        }
        
    }
endOfMethod:;
    
}

-(void) isAbleToPickupMine:(MineLayer *)mineLayer{
    for(int i = 0; i<30; i++){
        for(int j = 0; j<30; j++){
            if([_gameMap.grid[i][j] isKindOfClass:[NSNumber class]]){
                Terrain tertype = [_gameMap.grid[i][j] intValue];
                if(tertype == MINE){
                    NSLog(@"MINE: x: %i y: %i", i, j);
                }
            }
        }
    }
    [mineLayer.viableActions removeObject:@"PickupMine"];
    if(mineLayer.location.direction == NORTH){
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = mineLayer.location.xCoord+1;
        rightOfShip1.yCoord = mineLayer.location.yCoord;
        rightOfShip2.xCoord = mineLayer.location.xCoord+1;
        rightOfShip2.yCoord = mineLayer.location.yCoord-1;
        leftOfShip1.xCoord = mineLayer.location.xCoord-1;
        leftOfShip1.yCoord = mineLayer.location.yCoord;
        leftOfShip2.xCoord = mineLayer.location.xCoord-1;
        leftOfShip2.yCoord = mineLayer.location.yCoord-1;
        aboveShip.yCoord = mineLayer.location.yCoord+1;
        aboveShip.xCoord = mineLayer.location.xCoord;
        belowShip.xCoord = mineLayer.location.xCoord;
        belowShip.yCoord = mineLayer.location.yCoord-2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        
        
        for(Coordinate *c in coordinates){
            if([c isWithinMap]){
                
                if ([_gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    
                    Terrain terType = [_gameMap.grid[c.xCoord][c.yCoord] intValue];
                    if(terType == MINE){
                        
                        [mineLayer.viableActions addObject:@"PickupMine"];
                        goto endOfMethod;
                    }
                    
                    
                }
                
            }
            
        }
        
    }
    else{
        
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = mineLayer.location.xCoord+1;
        rightOfShip1.yCoord = mineLayer.location.yCoord;
        rightOfShip2.xCoord = mineLayer.location.xCoord+1;
        rightOfShip2.yCoord = mineLayer.location.yCoord+1;
        leftOfShip1.xCoord = mineLayer.location.xCoord-1;
        leftOfShip1.yCoord = mineLayer.location.yCoord;
        leftOfShip2.xCoord = mineLayer.location.xCoord-1;
        leftOfShip2.yCoord = mineLayer.location.yCoord+1;
        aboveShip.yCoord = mineLayer.location.yCoord-1;
        aboveShip.xCoord = mineLayer.location.xCoord;
        belowShip.xCoord = mineLayer.location.xCoord;
        belowShip.yCoord = mineLayer.location.yCoord+2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        for(Coordinate *c in coordinates){
            
            if([c isWithinMap]){
                
                if ([_gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    
                    Terrain terType = [_gameMap.grid[c.xCoord][c.yCoord] intValue];
                    
                    if(terType == MINE){
                        NSLog(@"Test");
                        [mineLayer.viableActions addObject:@"PickupMine"];
                        
                        goto endOfMethod;
                        
                    }
                    
                }
                
            }
            
        }
        
    }
endOfMethod:;
    
}



-(void) removeBaseSquare:(Coordinate *)destroyedBaseSquare {
    [_gameMap.grid[destroyedBaseSquare.xCoord] removeObjectAtIndex:destroyedBaseSquare.yCoord];
    [_gameMap.grid[destroyedBaseSquare.xCoord] insertObject:[NSNumber numberWithInt:WATER] atIndex:destroyedBaseSquare.yCoord];
    if (_localPlayer.isHost) {
        if (destroyedBaseSquare.yCoord == 0) {
            [self updateDockingZone];
        }
    }
    else {
        if (destroyedBaseSquare.yCoord == 29) {
            [self updateDockingZone];
        }
    }
    
    
}
-(void)updateDockingZone {
    _localPlayer.playerFleet.dockingCoordinates = [[NSMutableArray alloc] init];
    if(_localPlayer.isHost) {
        for (int i = 10; i < 20; i++) {
            if ([_gameMap.grid[i][0] isKindOfClass:[NSNumber class]]) {
                Terrain t = [_gameMap.grid[i][0] intValue];
                if (t == HOST_BASE) {
                    Coordinate *c = [[Coordinate alloc]initWithXCoordinate:i YCoordinate:0 initiallyFacing:NONE];
                    [self addAdjacentSquaresToDockingZone:c];
                }
                
            }
        }
    }
    else {
        for (int i = 10; i < 20; i++) {
            if ([_gameMap.grid[i][29] isKindOfClass:[NSNumber class]]) {
                Terrain t = [_gameMap.grid[i][29] intValue];
                if (t == HOST_BASE) {
                    Coordinate *c = [[Coordinate alloc]initWithXCoordinate:i YCoordinate:29 initiallyFacing:NONE];
                    [self addAdjacentSquaresToDockingZone:c];
                }
                
            }
        }
    }
}
-(void) addAdjacentSquaresToDockingZone: (Coordinate*) c {
    if (c.yCoord == 0) {
        for (int i = -1; i <=1; i++) {
            for (int j = 0; j <=1; j++) {
                if ((i != 0 && j == 0) || (i == 0 && j == 1)) {
                    Coordinate *dockCoord = [[Coordinate alloc] initWithXCoordinate:c.xCoord+i YCoordinate:c.yCoord+j initiallyFacing:NONE];
                    if ([dockCoord isWithinMap]) {
                        [_localPlayer.playerFleet.dockingCoordinates addObject:dockCoord];
                        if ([_gameMap.grid[dockCoord.xCoord][dockCoord.yCoord] isKindOfClass:[NSNumber class]]) {
                            Terrain t = [_gameMap.grid[dockCoord.xCoord][dockCoord.yCoord] intValue];
                            if (t == HOST_BASE) {
                                [_localPlayer.playerFleet.dockingCoordinates removeObject:dockCoord];
                            }
                        }
                    }
                }
            }
        }
    }
    else {
        for (int i = -1; i <=1; i++) {
            for (int j = 0; j <=1; j++) {
                if ((i != 0 && j == 0) || (i == 0 && j == 1)) {
                    Coordinate *dockCoord = [[Coordinate alloc] initWithXCoordinate:c.xCoord+i YCoordinate:c.yCoord-j initiallyFacing:NONE];
                    if ([c isWithinMap]) {
                        [_localPlayer.playerFleet.dockingCoordinates addObject:dockCoord];
                        if ([_gameMap.grid[dockCoord.xCoord][dockCoord.yCoord] isKindOfClass:[NSNumber class]]) {
                            Terrain t = [_gameMap.grid[dockCoord.xCoord][dockCoord.yCoord] intValue];
                            if (t == JOIN_BASE) {
                                [_localPlayer.playerFleet.dockingCoordinates removeObject:dockCoord];
                            }
                            
                        }
                    }
                }
            }
        }
    }
}




@end