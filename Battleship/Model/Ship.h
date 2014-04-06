//
//  Ship.h
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
#import "Range.h"
#import "ShipSegment.h"
#import "ShipArmourType.h"
#import "ShipRotation.h"
#import "WeaponType.h"

@interface Ship : NSObject

@property (strong, nonatomic) NSMutableArray* blocks; //of ShipSegment
@property int size;
@property int maxSpeed;
@property int speed;
@property ShipArmour shipArmourType;
@property Coordinate *location;
@property Range *radarRange;
@property Range *canonRange;
@property NSString *shipName;
@property NSMutableArray* viableActions; //of Strings

@property NSMutableArray* visibleCoordinates;
@property NSMutableArray* visibleCannonCoordinates;
@property BOOL isDestroyed;

- (instancetype) initWithLocation: (Coordinate*) initialPosition
                          andName:(NSString*) nameOfShip;
-(void)positionShip:(Coordinate *)destination isHost:(BOOL)host dockingArray:(NSMutableArray*)dock;
- (void)repair;
- (void)rotate: (Rotation)destination;
- (NSMutableArray*) getHeadLocationsOfMove;
-(void) damageShipWithTorpedoAt:(int)blockNumber and:(NSMutableArray*)dock;
-(void) toggleRepairStatus: (NSMutableArray*) dock;
-(void) changeSpeed;
@end

