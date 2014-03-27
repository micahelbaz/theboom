//
//  VisualBar.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Constants.h"
#import "Helpers.h"
#import "BattleshipGame.h"
#import "Foreground.h"

@interface VisualBar : NSObject

// The Visual Bar container
@property (strong, nonatomic) SKNode *visualBarNode;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Foreground *foreground;
@property (strong, nonatomic) Helpers *helper;

@property (strong, nonatomic) SKNode *shipFunctions;
@property (strong, nonatomic) SKNode *shipClicked;
@property (strong, nonatomic) SKNode *shipClickedName;
@property (strong, nonatomic) SKSpriteNode *shipActuallyClicked;

- (instancetype) initVisualBarWithNode:(SKNode*) visualBarNode
                               andGame:(BattleshipGame*) game
                         andForeground:(Foreground*) foreground
                             andHelper:(Helpers*) helper;

- (void) displayShipDetails: (SKNode*) shipSprite;
- (void) detectFunction: (SKNode*) functionSprite;
//- (void) updateShipLocation:(SKNode*) newShipLocation;

@end