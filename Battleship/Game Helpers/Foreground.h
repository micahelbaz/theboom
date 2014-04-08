//
//  Foreground.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "BattleshipGame.h"
#import "Helpers.h"
#import "Console.h"

@interface Foreground : NSObject

// The Foreground container
@property (strong, nonatomic) SKNode *foregroundNode;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Helpers *helper;
@property (strong, nonatomic) Console *console;

@property (strong, nonatomic) SKNode *movementLocationsSprites;
@property (strong, nonatomic) SKNode *torpedoSprites;
@property (strong, nonatomic) SKNode *canonRangeSprites;
@property (strong, nonatomic) SKNode *mineRangeSprites;
@property (strong, nonatomic) SKNode *pickupMineRangeSprites;

@property (strong, nonatomic) NSMutableArray *torpedoShot;
@property (strong, nonatomic) NSMutableArray *torpedoShooter;

@property NSInteger torpedoIntervals;



- (instancetype) initForegroundWithNode:(SKNode*) foregroundNode
                                andGame:(BattleshipGame*) game
                              andHelper:(Helpers*) helper
                             andConsole:(Console*) console;

- (void) displayMoveAreasForShip:(SKNode*)shipActuallyClicked;
- (void) createTorpedo:(SKNode*)shipActuallyClicked;
- (void) animateTorpedo;
- (void) displayCannonRange:(SKNode*)shipActuallyClicked;
- (void) displayMineRange:(SKNode*)shipActuallyAclicked;
- (void) displayPickupMineRange:(SKNode*)shipActuallyAclicked;

@end
