//
//  MiniMap.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Constants.h"
#import "BattleshipGame.h"

@interface MiniMap : NSObject

// Mini map size
@property float miniMapLength;

// The Mini Map container
@property (strong, nonatomic) SKNode *miniMapNode;
@property (strong, nonatomic) BattleshipGame *game;
@property Boolean initiallyTouched;

// Mini Map positions
@property (strong, nonatomic) NSMutableArray* miniMapPositions;

- (instancetype) initMiniMapWithNode:(SKNode*) miniMapNode
                             andGame:(BattleshipGame*) game;
- (void) setMiniMapLocation:(CGPoint)location;
- (void) updateMiniMapPositionWithTranslation:(CGPoint)translation;

- (void) animateMiniMapWithShip:(SKSpriteNode*) ship
                    andNewCoord:(Coordinate*) newCoord
                    andOldCoord:(Coordinate*) oldCoord
                   andIntervals:(NSInteger) shipIntervals;
@end
