//
//  Ship.m
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Ship.h"

@implementation Ship

-(instancetype) initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip {
    self = [super init];
    if (self) {
        _shipName = nameOfShip;
        _location = initialPosition;
        self.blocks = [[NSMutableArray alloc] init];
        self.viableActions = [[NSMutableArray alloc] init];
        self.isDestroyed = FALSE;
        self.radarRange = [[Range alloc]init];
        [_viableActions addObject:@"Move"];
        [_viableActions addObject:@"Rotate"];
        _visibleCoordinates = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)repair {
    for (int i = 0; i < self.size; i++) {
        ShipSegment *nextSeg = self.blocks[i];
        if (nextSeg.segmentArmourType != self.shipArmourType) {
            nextSeg.segmentArmourType = self.shipArmourType;
            break;
        }
    }
}

-(void)positionShip:(Coordinate *)destination isHost:(BOOL)host {
    Coordinate* newCoord = [[Coordinate alloc] initWithXCoordinate:destination.xCoord YCoordinate:destination.yCoord initiallyFacing:destination.direction];
    _location = newCoord;
    int i = 0;
    for (ShipSegment* seg in self.blocks) {
                switch (newCoord.direction) {
            case NORTH:
                seg.location.xCoord = newCoord.xCoord;
                seg.location.yCoord = newCoord.yCoord - i;
                break;
            case SOUTH:
                seg.location.xCoord = newCoord.xCoord;
                seg.location.yCoord = newCoord.yCoord + i;
                break;
            default:
                break;
        }
        i++;
    }
    if(host){
    _visibleCoordinates = [[NSMutableArray alloc]init];
    Coordinate *firstBlock = [[Coordinate alloc] initWithXCoordinate:newCoord.xCoord YCoordinate:newCoord.yCoord initiallyFacing:newCoord.direction];
    if(newCoord.direction == NORTH){
        firstBlock.yCoord-=(self.size-1);
        [self.visibleCoordinates addObject:firstBlock];
        int xRange = firstBlock.xCoord-self.radarRange.rangeWidth;
        
        int yRange = newCoord.yCoord-self.size+2+self.radarRange.startRange;
       
       
        for(int i = xRange; i<=firstBlock.xCoord+self.radarRange.rangeWidth; i++){
            for(int j = yRange; j<newCoord.yCoord+self.radarRange.rangeHeight; j++){
                Coordinate *c = [[Coordinate alloc]initWithXCoordinate:i YCoordinate:j initiallyFacing:NORTH];
                if([c isWithinMap]){
                    [self.visibleCoordinates addObject:c];
                    
                }
            }
        }
        
    }
    if(newCoord.direction == SOUTH){
        NSLog(@"top of function");
        firstBlock.yCoord+=(self.size-1);
        [self.visibleCoordinates addObject:firstBlock];
        int xRange = firstBlock.xCoord-self.radarRange.rangeWidth;
        NSLog(@"firstBloc.xCoord: %d", firstBlock.xCoord);
        NSLog(@"self.radarRange.rangeWidth: %d", self.radarRange.rangeWidth);
        
        NSLog(@"xRange: %d", xRange);

        int yRange = newCoord.yCoord+self.size-2-self.radarRange.startRange;
         NSLog(@"yRange: %d", yRange);
         NSLog(@"for loop max: %d", firstBlock.xCoord+self.radarRange.rangeWidth);
        for(int i = xRange; i<=firstBlock.xCoord+self.radarRange.rangeWidth; i++){
            for(int j = yRange; j>newCoord.yCoord-self.radarRange.rangeHeight-self.radarRange.startRange; j--){
                Coordinate *c = [[Coordinate alloc]initWithXCoordinate:i YCoordinate:j initiallyFacing:SOUTH];
                if([c isWithinMap]){
                    NSLog(@"inside if");
                    [self.visibleCoordinates addObject:c];
                    NSLog(@"x: %d, y: %d", c.xCoord, c.yCoord);
                }
            }
        }
        
    }
    
    if(newCoord.direction == WEST){
        firstBlock.xCoord+=(self.size-1);
        [self.visibleCoordinates addObject:firstBlock];
        int xRange = (newCoord.xCoord)-self.radarRange.rangeHeight;
        int yRange = firstBlock.yCoord-self.radarRange.rangeWidth;
        for(int i = xRange; i<=firstBlock.xCoord+self.radarRange.startRange; i++){
            for(int j = yRange; j>firstBlock.yCoord+self.radarRange.rangeWidth; j--){
                Coordinate *c = [[Coordinate alloc]initWithXCoordinate:i YCoordinate:j initiallyFacing:WEST];
                if([c isWithinMap]){
                    [self.visibleCoordinates addObject:c];
                }
            }
        }
        
    }
    if(newCoord.direction == EAST){
        firstBlock.xCoord+=(self.size-1);
        [self.visibleCoordinates addObject:firstBlock];
        int xRange = (firstBlock.xCoord+1)+self.radarRange.startRange;
        int yRange = firstBlock.yCoord-self.radarRange.rangeWidth;
        for(int i = xRange; i<=newCoord.xCoord+self.radarRange.rangeHeight; i++){
            for(int j = yRange; j>firstBlock.yCoord+self.radarRange.rangeWidth; j--){
                Coordinate *c = [[Coordinate alloc]initWithXCoordinate:i YCoordinate:j initiallyFacing:EAST];
                if([c isWithinMap]){
                    [self.visibleCoordinates addObject:c];
                }
            }
        }
        
    }
    
    }
}

-(void)rotate:(Rotation) destination {
    //abstract class
}

-(NSMutableArray *)getHeadLocationsOfMove {
    NSMutableArray* viableMoves = [[NSMutableArray alloc] init];
    NSMutableArray* headLocations = [[NSMutableArray alloc] init];
    ShipSegment* headSeg = self.blocks[0];
    for (int i = -1; i <= 1; i++) {
        if (i != 0) {
            Coordinate* headLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
            headLocation.xCoord = headSeg.location.xCoord;
            headLocation.yCoord = headSeg.location.yCoord;
            headLocation.direction = headSeg.location.direction;
            switch (headLocation.direction) {
                case NORTH:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    break;
                case SOUTH:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    break;
                case WEST:
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                case EAST:
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                default:
                    break;
            }
            [headLocations addObject:headLocation];
        }
    }
    for (int i = -1; i <= self.speed; i++) {
        if (i != 0) {
            Coordinate* headLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
            headLocation.xCoord = headSeg.location.xCoord;
            headLocation.yCoord = headSeg.location.yCoord;
            headLocation.direction = headSeg.location.direction;
            switch (headLocation.direction) {
                case NORTH:
                    headLocation.xCoord = headSeg.location.xCoord;
                    headLocation.yCoord = headSeg.location.yCoord + i;
                    break;
                case SOUTH:
                    headLocation.xCoord = headSeg.location.xCoord;
                    headLocation.yCoord = headSeg.location.yCoord - i;
                    break;
                case WEST:
                    headLocation.xCoord = headSeg.location.xCoord - i;
                    headLocation.yCoord = headSeg.location.yCoord;
                    break;
                case EAST:
                    headLocation.xCoord = headSeg.location.xCoord + i;
                    headLocation.yCoord = headSeg.location.yCoord;
                    break;
                default:
                    break;
                    
            }
            [headLocations addObject:headLocation];
        }
    }
    NSMutableArray *coordsToBeRemoved = [[NSMutableArray alloc] init];
    for (Coordinate *headLocation in headLocations) {
        Coordinate *tailLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
        tailLocation.xCoord = headLocation.xCoord;
        tailLocation.yCoord = headLocation.yCoord;
        tailLocation.direction = headLocation.direction;
        switch (headLocation.direction) {
            case NORTH:
                tailLocation.yCoord = headLocation.yCoord - (self.size - 1);
                break;
            case SOUTH:
                tailLocation.yCoord = headLocation.yCoord + (self.size - 1);
                break;
            case WEST:
                tailLocation.xCoord = headLocation.xCoord + (self.size - 1);
                break;
            case EAST:
                tailLocation.xCoord = headLocation.xCoord - (self.size - 1);
                break;
            default:
                break;
        }
        if (![headLocation isWithinMap]) {
            [coordsToBeRemoved addObject:headLocation];
        }
        if(![tailLocation isWithinMap]) {
            [coordsToBeRemoved addObject:headLocation];
        }
    }
    for (Coordinate *c in coordsToBeRemoved) {
        [headLocations removeObject:c];
    }
    for (Coordinate* headLocation in headLocations) {
        NSMutableArray *shipLocations = [[NSMutableArray alloc] init];
        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
        segmentLocation.xCoord = headLocation.xCoord;
        segmentLocation.yCoord = headLocation.yCoord;
        segmentLocation.direction = headLocation.direction;
        switch (headLocation.direction) {
            case NORTH:
                if (headLocation.yCoord > headSeg.location.yCoord) {
                    for (int i = headLocation.yCoord; i > headSeg.location.yCoord; i--) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:headLocation.xCoord YCoordinate:i initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                else {
                    for (int i = 0; i < self.size; i++) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:headLocation.xCoord YCoordinate:headLocation.yCoord - i initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                break;
            case SOUTH:
                if (headLocation.yCoord < headSeg.location.yCoord) {
                    for (int i = headLocation.yCoord; i < headSeg.location.yCoord; i++) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:headLocation.xCoord YCoordinate:i initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                else {
                    for (int i = 0; i < self.size; i++) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:headLocation.xCoord YCoordinate:headLocation.yCoord + i initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                break;
            case WEST:
                if (headLocation.xCoord < headSeg.location.xCoord) {
                    for (int i = headLocation.xCoord; i < headSeg.location.xCoord; i++) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:headLocation.yCoord initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                else {
                    for (int i = 0; i < self.size; i++) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:headLocation.xCoord + i YCoordinate:headLocation.yCoord initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                break;
            case EAST:
                if (headLocation.xCoord > headSeg.location.xCoord) {
                    for (int i = headLocation.xCoord; i > headSeg.location.xCoord; i--) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:headLocation.yCoord initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                else {
                    for (int i = 0; i < self.size; i++) {
                        Coordinate *segmentLocation = [[Coordinate alloc] initWithXCoordinate:headLocation.xCoord - i YCoordinate:headLocation.yCoord initiallyFacing:headLocation.direction];
                        [shipLocations addObject:segmentLocation];
                    }
                }
                break;
            default:
                break;
        }
        [viableMoves addObject:shipLocations];
    }
    return viableMoves;
}

-(void) damageShipWithTorpedoAt:(int)blockNumber {
    ShipSegment* seg = _blocks[blockNumber];
    if (seg.segmentArmourType == HEAVY_ARMOUR || seg.segmentArmourType == NORMAL_ARMOUR) {
        seg.segmentArmourType--;
    }
    /*
     if (blockNumber > 0) {
     if (![_blocks[blockNumber-1] damageSegmentWithTorpedo] && blockNumber < _size-1) {
     [_blocks[blockNumber+1] damageSegmentWithTorpedo];
     }
     }
     else {
     [_blocks[blockNumber+1] damageSegmentWithTorpedo];
     }
     */
    int counter = 0;
    for (int i = 0; i < _size; i++) {
        ShipSegment *s = _blocks[i];
        NSLog(@"armour %d", s.segmentArmourType);
        if (s.segmentArmourType == DESTROYED) {
            NSLog(@"armour %d", s.segmentArmourType);
            counter++;
        }
    }
    if (counter == _size) {
        _isDestroyed = TRUE;
    }
    else {
        double doubleSpeed = (double)(_size-counter)/ (double)_size * (double)_maxSpeed;
        _speed = (int) doubleSpeed;
    }
    
}
@end
