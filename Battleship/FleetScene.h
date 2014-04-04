//
//  FleetScene.h
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-25.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Coordinate.h"
#import "BattleshipGame.h"

@interface FleetScene : SKScene <GKMatchDelegate>

@property (nonatomic, strong) BattleshipGame *game;
@property (nonatomic, strong) SKSpriteNode *fleetBackground;
@property (nonatomic, strong) NSMutableArray *unplacedShips;
@property (nonatomic, strong) NSMutableArray* placedShip;
@property (nonatomic, strong) NSMutableSet *coralPositions;
@property int lastIndex;
@property BOOL configurationSet;
@end
