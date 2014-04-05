//
//  Fleet.m
//  Battleship
//
//  Created by Micah Elbaz on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Fleet.h"

@implementation Fleet

#pragma mark - TODO: the coordinate setting system is broken. please fix.

- (instancetype)initWith:(BOOL)isHost andShips:(NSMutableArray*) ships
{
    self = [super init];
    if(self){
        Coordinate *cruiser1;
        Coordinate *cruiser2;
        Coordinate *destroyer1;
        Coordinate *destroyer2;
        Coordinate *destroyer3;
        Coordinate *torpedo1;
        Coordinate *torpedo2;
        Coordinate *mineLayer1;
        Coordinate *mineLayer2;
        Coordinate *radar1;
        Cruiser *c1;
        Cruiser *c2;
        Destroyer *d1;
        Destroyer *d2;
        Destroyer *d3;
        TorpedoBoat *t1;
        TorpedoBoat *t2;
        MineLayer *m1;
        MineLayer *m2;
        RadarBoat *r1;
        self.dockingCoordinates = [[NSMutableArray alloc]init];
        self.baseCoordinates = [[NSMutableArray alloc]init];
        if(isHost){
            for (int i = 0; i < ships.count; i++) {
                if ([ships[i] intValue] == 0) {
                    cruiser1 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:5 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 1) {
                    cruiser2 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:5 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 2) {
                    destroyer1 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:4 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 3) {
                    destroyer2 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:4 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 4) {
                    destroyer3 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:4 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 5) {
                    torpedo1 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:3 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 6) {
                    torpedo2 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:3 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 7) {
                    mineLayer1 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:2 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 8) {
                    mineLayer2 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:2 initiallyFacing:NORTH];
                }
                if ([ships[i] intValue] == 9) {
                    radar1 = [[Coordinate alloc] initWithXCoordinate:10+i YCoordinate:3 initiallyFacing:NORTH];
                }
            }
            
            
//            cruiser1 = [[Coordinate alloc] initWithXCoordinate:19 YCoordinate:5 initiallyFacing:NORTH];
//            cruiser2 = [[Coordinate alloc] initWithXCoordinate:18 YCoordinate:5 initiallyFacing:NORTH];
//            destroyer1 = [[Coordinate alloc] initWithXCoordinate:17 YCoordinate:4 initiallyFacing:NORTH];
//            destroyer2 = [[Coordinate alloc] initWithXCoordinate:16 YCoordinate:4 initiallyFacing:NORTH];
//            destroyer3 = [[Coordinate alloc] initWithXCoordinate:15 YCoordinate:4 initiallyFacing:NORTH];
//            torpedo1 = [[Coordinate alloc] initWithXCoordinate:14 YCoordinate:3 initiallyFacing:NORTH];
//            torpedo2 = [[Coordinate alloc] initWithXCoordinate:13 YCoordinate:3 initiallyFacing:NORTH];
//            mineLayer1 = [[Coordinate alloc] initWithXCoordinate:12 YCoordinate:2 initiallyFacing:NORTH];
//            mineLayer2 = [[Coordinate alloc] initWithXCoordinate:11 YCoordinate:2 initiallyFacing:NORTH];
//            radar1 = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:3 initiallyFacing:NORTH];
            c1 = [[Cruiser alloc] initWithLocation: cruiser1 andName:@"HostCruiser1"];
            c2 = [[Cruiser alloc] initWithLocation: cruiser2 andName:@"HostCruiser2"];
            d1 = [[Destroyer alloc] initWithLocation: destroyer1 andName:@"HostDestroyer1"];
            d2 = [[Destroyer alloc] initWithLocation: destroyer2 andName:@"HostDestroyer2"];
            d3 = [[Destroyer alloc] initWithLocation: destroyer3 andName:@"HostDestroyer3"];
            t1 = [[TorpedoBoat alloc] initWithLocation: torpedo1 andName:@"HostTorpedoBoat1"];
            t2 = [[TorpedoBoat alloc] initWithLocation: torpedo2 andName:@"HostTorpedoBoat2"];
            m1 = [[MineLayer alloc] initWithLocation: mineLayer1 andName:@"HostMineLayer1"];
            m2 = [[MineLayer alloc] initWithLocation: mineLayer2 andName:@"HostMineLayer2"];
            r1 = [[RadarBoat alloc] initWithLocation: radar1 andName:@"HostRadarBoat1"];
        [c1 positionShip:cruiser1 isHost:TRUE dockingArray:self.dockingCoordinates];
        [c2 positionShip:cruiser2 isHost:TRUE dockingArray:self.dockingCoordinates];
        [d1 positionShip:destroyer1 isHost:TRUE dockingArray:self.dockingCoordinates];
        [d2 positionShip:destroyer2 isHost:TRUE dockingArray:self.dockingCoordinates];
        [d3 positionShip:destroyer3 isHost:TRUE dockingArray:self.dockingCoordinates];
        [t1 positionShip:torpedo1 isHost:TRUE dockingArray:self.dockingCoordinates];
        [t2 positionShip:torpedo2 isHost:TRUE dockingArray:self.dockingCoordinates];
        [m1 positionShip:mineLayer1 isHost:TRUE dockingArray:self.dockingCoordinates];
        [m2 positionShip:mineLayer2 isHost:TRUE dockingArray:self.dockingCoordinates];
        [r1 positionShip:radar1 isHost:TRUE dockingArray:self.dockingCoordinates];
        }
        else{
            for (int i = 0; i < ships.count; i++) {
                if ([ships[i] intValue] == 0) {
                    cruiser1 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:24 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 1) {
                    cruiser2 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:24 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 2) {
                    destroyer1 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:25 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 3) {
                    destroyer2 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:25 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 4) {
                    destroyer3 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:25 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 5) {
                    torpedo1 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:26 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 6) {
                    torpedo2 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:26 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 7) {
                    mineLayer1 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:27 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 8) {
                    mineLayer2 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:27 initiallyFacing:SOUTH];
                }
                if ([ships[i] intValue] == 9) {
                    radar1 = [[Coordinate alloc] initWithXCoordinate:19-i YCoordinate:26 initiallyFacing:SOUTH];
                }
            }
//            cruiser1 = [[Coordinate alloc] initWithXCoordinate:19 YCoordinate:24 initiallyFacing:SOUTH];
//            cruiser2 = [[Coordinate alloc] initWithXCoordinate:18 YCoordinate:24 initiallyFacing:SOUTH];
//            destroyer1 = [[Coordinate alloc] initWithXCoordinate:17 YCoordinate:25 initiallyFacing:SOUTH];
//            destroyer2 = [[Coordinate alloc] initWithXCoordinate:16 YCoordinate:25 initiallyFacing:SOUTH];
//            destroyer3 = [[Coordinate alloc] initWithXCoordinate:15 YCoordinate:25 initiallyFacing:SOUTH];
//            torpedo1 = [[Coordinate alloc] initWithXCoordinate:14 YCoordinate:26 initiallyFacing:SOUTH];
//            torpedo2 = [[Coordinate alloc] initWithXCoordinate:13 YCoordinate:26 initiallyFacing:SOUTH];
//            mineLayer1 = [[Coordinate alloc] initWithXCoordinate:12 YCoordinate:27 initiallyFacing:SOUTH];
//            mineLayer2 = [[Coordinate alloc] initWithXCoordinate:11 YCoordinate:27 initiallyFacing:SOUTH];
//            radar1 = [[Coordinate alloc] initWithXCoordinate:10 YCoordinate:26 initiallyFacing:SOUTH];
            c1 = [[Cruiser alloc] initWithLocation: cruiser1 andName:@"JoinCruiser1"];
            c2 = [[Cruiser alloc] initWithLocation: cruiser2 andName:@"JoinCruiser2"];
            d1 = [[Destroyer alloc] initWithLocation: destroyer1 andName:@"JoinDestroyer1"];
            d2 = [[Destroyer alloc] initWithLocation: destroyer2 andName:@"JoinDestroyer2"];
            d3 = [[Destroyer alloc] initWithLocation: destroyer3 andName:@"JoinDestroyer3"];
            t1 = [[TorpedoBoat alloc] initWithLocation: torpedo1 andName:@"JoinTorpedoBoat1"];
            t2 = [[TorpedoBoat alloc] initWithLocation: torpedo2 andName:@"JoinTorpedoBoat2"];
            m1 = [[MineLayer alloc] initWithLocation: mineLayer1 andName:@"JoinMineLayer1"];
            m2 = [[MineLayer alloc] initWithLocation: mineLayer2 andName:@"JoinMineLayer2"];
            r1 = [[RadarBoat alloc] initWithLocation: radar1 andName:@"JoinRadarBoat1"];
            if(isHost){
                for(int i = 10; i<20; i++){
                    Coordinate *c = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:0 initiallyFacing:NONE];
                    [self.baseCoordinates addObject:c];
                    Coordinate *coord = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:1 initiallyFacing:NONE];
                    [self.dockingCoordinates addObject:coord];
                }
                Coordinate *leftOfBase = [[Coordinate alloc] initWithXCoordinate:9 YCoordinate:0 initiallyFacing:NONE];
                Coordinate *rightOfBase = [[Coordinate alloc] initWithXCoordinate:20 YCoordinate:0 initiallyFacing:NONE];
                [self.dockingCoordinates addObject:leftOfBase];
                [self.dockingCoordinates addObject:rightOfBase];
            }
            else{
                for(int i = 10; i<20; i++){
                    Coordinate *c = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:29 initiallyFacing:NONE];
                    [self.baseCoordinates addObject:c];
                    Coordinate *coord = [[Coordinate alloc] initWithXCoordinate:i YCoordinate:28 initiallyFacing:NONE];
                    [self.dockingCoordinates addObject:coord];
                    Coordinate *leftOfBase = [[Coordinate alloc] initWithXCoordinate:9 YCoordinate:29 initiallyFacing:NONE];
                    Coordinate *rightOfBase = [[Coordinate alloc] initWithXCoordinate:20 YCoordinate:29 initiallyFacing:NONE];
                    [self.dockingCoordinates addObject:leftOfBase];
                    [self.dockingCoordinates addObject:rightOfBase];
                    
                }
            }
        [c1 positionShip:cruiser1 isHost:FALSE dockingArray:self.dockingCoordinates];
        [c2 positionShip:cruiser2 isHost:FALSE dockingArray:self.dockingCoordinates];
        [d1 positionShip:destroyer1 isHost:FALSE dockingArray:self.dockingCoordinates];
        [d2 positionShip:destroyer2 isHost:FALSE dockingArray:self.dockingCoordinates];
        [d3 positionShip:destroyer3 isHost:FALSE dockingArray:self.dockingCoordinates];
        [t1 positionShip:torpedo1 isHost:FALSE dockingArray:self.dockingCoordinates];
        [t2 positionShip:torpedo2 isHost:FALSE dockingArray:self.dockingCoordinates];
        [m1 positionShip:mineLayer1 isHost:FALSE dockingArray:self.dockingCoordinates];
        [m2 positionShip:mineLayer2 isHost:FALSE dockingArray:self.dockingCoordinates];
        [r1 positionShip:radar1 isHost:FALSE dockingArray:self.dockingCoordinates];
    
        }
     
        
        self.shipArray = [NSArray arrayWithObjects:c1,c2,d1,d2,d3,t1,t2,m1,m2,r1, nil];
    }
    return self;
}

-(Ship*) getShipWithCoord:(Coordinate *)location {
    for (Ship *s in _shipArray) {
        for (ShipSegment *seg in s.blocks) {
            if (seg.location.xCoord == location.xCoord && seg.location.yCoord == location.yCoord) {
                return s;
            }
        }
    }
    return Nil;
}

@end

