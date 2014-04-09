//
//  Kamikaze.m
//  Battleship
//
//  Created by Robert Schneidman on 2014-04-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Kamikaze.h"

@implementation Kamikaze
-(instancetype) initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip {
    self = [super initWithLocation:initialPosition andName:nameOfShip];
    if (self) {
        self.size = 1;
        self.maxSpeed = 2;
        self.speed = 2;
        self.shipArmourType = HEAVY_ARMOUR;
        [self.viableActions addObject:@"SelfDistruct"];
        for (int i = 0; i < self.size; i++) {
            Coordinate* segCoord = [[Coordinate alloc] init];
            segCoord.direction = initialPosition.direction;
            segCoord.xCoord = initialPosition.xCoord;
            switch (segCoord.direction) {
                case NORTH:
                    segCoord.yCoord = initialPosition.yCoord - i;
                    break;
                case SOUTH:
                    segCoord.yCoord = initialPosition.yCoord + i;
                    break;
                default:
                    break;
            }
            ShipSegment* nextSeg = [[ShipSegment alloc] initWithArmour:HEAVY_ARMOUR andPosition:i atLocation:segCoord belongingToShip:nameOfShip withShipSize:1];
            if (i == 0) {
                nextSeg.isHead = YES;
            }
            else {
                nextSeg.isHead = NO;
            }
            [self.blocks addObject:nextSeg];
        }
        self.radarRange.rangeHeight = 5;
        self.radarRange.rangeWidth = 2;
        self.radarRange.startRange = -3;

    }
    return self;
}
-(NSMutableArray *)getMoveLocations {
    NSMutableArray *movementLocations = [[NSMutableArray alloc] init];
    for (int i = -self.speed; i <= self.speed; i++) {
        for (int j = -self.speed; j <= self.speed; j++) {
            Coordinate *c = [[Coordinate alloc] initWithXCoordinate:self.location.xCoord + i YCoordinate:self.location.yCoord + j initiallyFacing:self.location.direction];
            if ([c isWithinMap]) {
                if (c.xCoord != self.location.xCoord || c.yCoord != self.location.yCoord) {
                    [movementLocations addObject:c];
                }
            }
        }
    }
    return movementLocations;
}

-(NSMutableArray *)getExplosionLocations {
    NSMutableArray *explosionLocations = [[NSMutableArray alloc] init];
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            Coordinate *c = [[Coordinate alloc] initWithXCoordinate:self.location.xCoord + i YCoordinate:self.location.yCoord + j initiallyFacing:self.location.direction];
            if ([c isWithinMap]) {
                if (c.xCoord != self.location.xCoord || c.yCoord != self.location.yCoord) {
                    [explosionLocations addObject:c];
                }
            }
        }
    }
    return explosionLocations;
}
@end
