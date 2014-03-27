//
//  MineLayer.h
//  Battleship
//
//  Created by Robert Schneidman on 2/3/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import "Ship.h"

@interface MineLayer : Ship

@property int numMines;
- (instancetype)initWithLocation:(Coordinate *)initialPosition andName:(NSString *)nameOfShip;

@end
