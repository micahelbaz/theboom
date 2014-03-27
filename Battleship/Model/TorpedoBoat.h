//
//  TorpedoBoat.h
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Ship.h"

@interface TorpedoBoat : Ship

- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip;

@end
