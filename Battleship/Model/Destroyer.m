//
//  Destroyer.m
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Destroyer.h"

@implementation Destroyer

- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip
{
    self = [super initWithLocation:initialPosition andName:nameOfShip];
    if (self) {
        self.size = 4;
        self.maxSpeed = 8;
        self.speed = 8;
        self.shipArmourType = NORMAL_ARMOUR;
        [self.viableActions addObject:@"FireTorpedo"];
        [self.viableActions addObject:@"FireCannon"];
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
            ShipSegment* nextSeg = [[ShipSegment alloc] initWithArmour:NORMAL_ARMOUR andPosition:i atLocation:segCoord belongingToShip:nameOfShip withShipSize:4];
            if (i == 0) {
                nextSeg.isHead = YES;
            }
            else {
                nextSeg.isHead = NO;
            }
            self.blocks[i] = nextSeg;
        }
        self.radarRange.rangeHeight = 8;
        self.radarRange.rangeWidth = 1;
        self.radarRange.startRange = 0;
        self.canonRange.rangeHeight = 7;
        self.canonRange.rangeWidth = 4;
        self.canonRange.startRange = -5;
    }
    return self;
}

-(void)rotate:(Rotation)destination{
    if(destination == RIGHT){
        if(self.location.direction == NORTH){
            self.location.xCoord+=3;
            self.location.yCoord-=3;
            self.location.direction=EAST;
        }
        if(self.location.direction == SOUTH){
            self.location.xCoord-=3;
            self.location.yCoord+=3;
            self.location.direction=WEST;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=3;
            self.location.yCoord+=3;
            self.location.direction=NORTH;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=3;
            self.location.yCoord-=3;
            self.location.direction=SOUTH;
        }
    }
    if(destination == LEFT){
        if(self.location.direction == NORTH){
            self.location.xCoord-=3;
            self.location.yCoord-=3;
            self.location.direction=WEST;
        }
        if(self.location.direction == SOUTH){
            self.location.xCoord+=3;
            self.location.yCoord+=3;
            self.location.direction=EAST;
        }
        if(self.location.direction == WEST){
            self.location.xCoord+=3;
            self.location.yCoord-=3;
            self.location.direction=SOUTH;
        }
        if(self.location.direction == EAST){
            self.location.xCoord-=3;
            self.location.yCoord+=3;
            self.location.direction=NORTH;
        }
    }
}
@end
