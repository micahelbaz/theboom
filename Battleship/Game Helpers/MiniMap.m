//
//  MiniMap.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MiniMap.h"

@implementation MiniMap

- (instancetype) initMiniMapWithNode:(SKNode*) miniMapNode
                             andGame:(BattleshipGame*) game{
    self = [super init];
    if (self) {
        _game = game;
        _miniMapNode = miniMapNode;
        [self setMiniMapPositions];
        [self initMiniMap];
    }
    return self;
}

// Sets the positions of the minimap
- (void) setMiniMapPositions{
    
    // Initilize CGPoints
    _miniMapPositions = [[NSMutableArray alloc] init];
    
    // Point locations
    CGPoint point1 = CGPointMake(fullScreenWidth - miniMapHeight - visualBarWidth,
                                 fullScreenHeight - miniMapHeight);
    CGPoint point2 = CGPointMake(miniMapHeight,
                                 fullScreenHeight - miniMapHeight);
    CGPoint point3 = CGPointMake(fullScreenWidth - miniMapHeight - visualBarWidth,
                                 miniMapHeight);
    CGPoint point4 = CGPointMake(miniMapHeight,
                                 miniMapHeight);
    
    // Adding to array
    [_miniMapPositions addObject:[NSValue valueWithCGPoint:point1]];
    [_miniMapPositions addObject:[NSValue valueWithCGPoint:point2]];
    [_miniMapPositions addObject:[NSValue valueWithCGPoint:point3]];
    [_miniMapPositions addObject:[NSValue valueWithCGPoint:point4]];
    
}

// Updates the mini map with a specific translation
- (void) updateMiniMapPositionWithTranslation:(CGPoint) translation{
    
    CGPoint position = [[_miniMapNode childNodeWithName:miniMapSpriteName ] position];
    [[_miniMapNode childNodeWithName:miniMapSpriteName]
     setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    
}

// Initializes mini map
- (void)initMiniMap{
    // Mini Map
    SKNode *miniMap = [SKSpriteNode spriteNodeWithImageNamed:miniMapImageName];
    miniMap.name = miniMapSpriteName;
    miniMap.yScale = 0.4;
    miniMap.xScale = 0.4;
    miniMap.position = [[_miniMapPositions objectAtIndex:0] CGPointValue];
    [_miniMapNode addChild:miniMap];
    
    // This player's ships
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    ShipSegment *s;
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            if ([_game.gameMap.grid[i][j] isKindOfClass:[ShipSegment class]])
            {
                s = _game.gameMap.grid[i][j];
                if (s.isHead) {
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:miniMapGreenDotImageName];
                    sprite.name = [NSString stringWithFormat:@"%@/Green Dot", s.shipName];
                    sprite.yScale = 0.3 * s.shipSize;
                    sprite.xScale = 0.3;
                    
                    if (s.location.direction == SOUTH)
                    {
                        sprite.position = CGPointMake(s.location.xCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.width*1.4, s.location.yCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.height*1.3 + s.shipSize*miniMap.frame.size.height/10 - (miniMap.frame.size.height/10 * 5));
                    }
                    
                    else if (s.location.direction == NORTH)
                    {
                        sprite.position = CGPointMake(s.location.xCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.width*1.4, s.location.yCoord*(miniMap.frame.size.height/10) - miniMap.frame.size.height*1.3 - s.shipSize*miniMap.frame.size.height/10 + (miniMap.frame.size.height/10 * 2));
                    }
                    [miniMap addChild:sprite];
                }
            }
        }
    }
}

- (void) animateMiniMapWithShip:(SKSpriteNode*) ship
                    andNewCoord:(Coordinate*) newCoord
                    andOldCoord:(Coordinate*) oldCoord
                   andIntervals:(NSInteger) shipIntervals {
    
    NSString* name = [NSString stringWithFormat:@"%@/Green Dot", ship.name];
    SKNode* thisShip = [_miniMapNode childNodeWithName:name];
    
    //NSLog(@"this is getting called");
    
    int difference = newCoord.yCoord - oldCoord.yCoord;
    CGFloat translation = (CGFloat) difference * (100 - (shipIntervals))/100;
    
    thisShip.position = CGPointMake((CGFloat)newCoord.xCoord * tileWidth + tileWidth/2,
                                ((CGFloat)oldCoord.yCoord) * tileHeight
                                + translation * tileHeight
                                - ship.frame.size.height/2 + tileHeight);
    
}

// Always set the minimap in a specific location - due to bugs with touching
- (void) setMiniMapLocation:(CGPoint)location {
    
    SKNode* minimap = [_miniMapNode childNodeWithName:miniMapSpriteName];
    
    CGFloat minDistance = FLT_MAX;
    CGFloat temp;
    CGFloat xDistance = 0;
    CGFloat yDistance = 0;
    CGPoint corner;
    int pos;
    
    // Comparing to the destination nodes
    for (int i = 0; i < [_miniMapPositions count]; i++)
    {
        corner = [[_miniMapPositions objectAtIndex:i] CGPointValue];
        xDistance = corner.x - location.x;
        yDistance = corner.y - location.y;
        temp = sqrt((xDistance * xDistance) + (yDistance * yDistance));
        if (temp < minDistance)
        {
            pos = i;
            minDistance = temp;
        }
        
    }
    minimap.position = [[_miniMapPositions objectAtIndex:pos] CGPointValue];
}

@end
