//
//  Coordinate.h
//  Battleship
//
//  Created by Robert Schneidman on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionType.h"
@interface Coordinate : NSObject

@property int xCoord;
@property int yCoord;
@property Direction direction;

- (instancetype) initWithXCoordinate: (int)xCoordinate
                         YCoordinate:(int) yCoordinate
                          initiallyFacing:(Direction) facingDirection;
- (BOOL) isWithinMap;

@end
