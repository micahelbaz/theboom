//
//  Ships.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Constants.h"
#import "BattleshipGame.h"
#import "Helpers.h"
#import "MiniMap.h"
#import "VisualBar.h"
#import "Console.h"

@interface Ships : NSObject

// The Ships container
@property (strong, nonatomic) SKNode *shipsNode;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Helpers *helper;
@property (strong, nonatomic) VisualBar *visualBar;
@property (strong, nonatomic) Foreground *foreground;
@property (strong, nonatomic) MiniMap *miniMap;
@property (strong, nonatomic) Console *console;
@property (strong, nonatomic) NSMutableArray *movingShip;
@property (strong, nonatomic) NSMutableArray *movingShipOldLocation;
@property (strong, nonatomic) NSMutableArray *movingShipNewLocation;

@property (strong, nonatomic) Fleet *hostFleet;
@property (strong, nonatomic) Fleet *opponentFleet;

@property NSInteger shipIntervals;


- (instancetype) initShipsWithNode:(SKNode*) shipsNode
                           andGame:(BattleshipGame*) game
                         andHelper:(Helpers*) helper
                      andVisualBar:(VisualBar*) visualBar
                     andForeground:(Foreground*) foreground
                        andMiniMap:(MiniMap*) miniMap
                        andConsole:(Console*) console;

- (void) updateShipLocation:(SKNode*) newShipLocation;
- (void) animateShips;
- (NSString*) shipName: (NSString*) carbon;
-(CGPoint)positionShipSprite:(SKNode *)sprite atCoordinate:(Coordinate *)c;
- (void) removeShipFromScreen: (NSString*) shipName;
@end
