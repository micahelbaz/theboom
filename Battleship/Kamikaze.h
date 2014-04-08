//
//  Kamikaze.h
//  Battleship
//
//  Created by Robert Schneidman on 2014-04-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Ship.h"

@interface Kamikaze : Ship

@property Range* moveRange;
- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip;
- (NSMutableArray*) getMoveLocations;
@end
