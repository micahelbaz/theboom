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
    if (self) {
        self.size = 1;
        self.maxSpeed = 2;
        self.speed = 2;
        self.shipArmourType = HEAVY_ARMOUR;
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
            ShipSegment* nextSeg = [[ShipSegment alloc] initWithArmour:HEAVY_ARMOUR andPosition:i atLocation:segCoord belongingToShip:nameOfShip withShipSize:5];
            if (i == 0) {
                nextSeg.isHead = YES;
            }
            else {
                nextSeg.isHead = NO;
            }
            self.blocks[i] = nextSeg;
        }
        self.radarRange.rangeHeight = 5;
        self.radarRange.rangeWidth = 2;
        self.radarRange.startRange = -3;

    }
    return self;
}
-(NSMutableArray *)getMoveLocations {
    NSMutableArray *movementLocations = [[NSMutableArray alloc] init];
    for (int i = -2; i <= 2; i++) {
        for (int i = -2; i <= 2; i++) {
            Coordinate *c = [[Coordinate alloc] initWithXCoordinate:self.location.xCoord + i YCoordinate:self.location.yCoord + i initiallyFacing:self.location.direction];
            if ([c isWithinMap]) {
                if (c.xCoord != self.location.xCoord && c.yCoord != self.location.yCoord) {
                    [movementLocations addObject:c];
                }
            }
        }
    }
    return nil;
}
@end
