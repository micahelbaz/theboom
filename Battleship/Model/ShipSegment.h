
//
//  ShipSegment.h
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipArmourType.h"
#import "Coordinate.h"

@interface ShipSegment : NSObject

@property ShipArmour segmentArmourType;
@property int block;
@property (strong, nonatomic) NSString* shipName;
@property (strong, nonatomic) Coordinate* location;
@property BOOL isHead;
@property int shipSize;

-(instancetype) initWithArmour:(ShipArmour) armour
                   andPosition:(int)cell
                    atLocation:(Coordinate*) initialLocation
               belongingToShip:(NSString*) ship
                  withShipSize: (int) shipSize;

-(BOOL) damageSegmentWithTorpedo;
@end

