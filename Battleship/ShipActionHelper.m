//
//  ShipActionHelper.m
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "ShipActionHelper.h"

@implementation ShipActionHelper

static ShipActionHelper *sharedHelper = nil;
+ (ShipActionHelper *)sharedInstance {
    if(!sharedHelper){
        sharedHelper = [[ShipActionHelper alloc] init];
    }
    return sharedHelper;
}

-(NSMutableArray*) getRotationRangeOf: (Ship*) s{
    NSMutableArray *validRotations = [[NSMutableArray alloc] init];
    if ([s isKindOfClass:[Cruiser class]] || [s isKindOfClass:[Destroyer class]] || [s isKindOfClass:[MineLayer class]]) {
        [self getRotationAroundTailAxis:s];
    }
    else if ([s isKindOfClass:[TorpedoBoat class]] || [s isKindOfClass:[RadarBoat class]]) {
        [self getRotationAroundCenterAxis:s];
    }
    return validRotations;
}
/*
-(NSMutableArray*) getRotationAroundCenterAxis: (Ship*) s{
    switch (s.location.direction) {
            
    }
}

-(NSMutableArray*) getRotationAroundTailAxis: (Ship*) s{
    NSMutableArray* headLocations = [[NSMutableArray alloc] init];
    switch (s.location.direction) {
        Coordinate* l = [Coordinate alloc] initWithXCoordinate:s.location.xCoord YCoordinate:s.location.yCoord initiallyFacing:<#(Direction)#>
        case NORTH:
            Coordinate* l
            break;
            
        default:
            break;
    }
}
 */
@end

