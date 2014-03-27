//
//  Background.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Background.h"

@implementation Background

- (instancetype) initBackgroundWithNode:(SKNode*) backgroundNode
                                andGame:(BattleshipGame*) game{
    self = [super init];
    if (self) {
        _game = game;
        _backgroundNode = backgroundNode;
        [self initBackgroundSprites];
        [self initTerrainSprites];
    }
    return self;
}


// Initializes the Background
- (void) initBackgroundSprites{
    
    SKSpriteNode* background1 = [SKSpriteNode spriteNodeWithImageNamed:waterBackgroundImageName];
    background1.anchorPoint = CGPointZero;
    background1.name = background1SpriteName;
    [_backgroundNode addChild:background1];
    
    SKSpriteNode* background2 = [SKSpriteNode spriteNodeWithImageNamed:waterBackgroundImageName];
    background2.anchorPoint = CGPointZero;
    background2.position = CGPointMake(background1.frame.size.width-1, 0);
    background2.name = background2SpriteName;
    [_backgroundNode addChild:background2];
}

// Initializes Terrain
- (void) initTerrainSprites{
    
    // Initilizes the different sprites
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    
    // Drawing the sprites to screen in position
    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            if ([_game.gameMap.grid[i][j] isKindOfClass:[NSNumber class]]) {
                Terrain terType = [_game.gameMap.grid[i][j] intValue];
                switch (terType)
                {
                    case HOST_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:miniMapGreenBaseImageName];
                        sprite.name = hostBaseSpriteName;
                        sprite.zRotation =  M_PI / 2;
                        sprite.xScale = tileWidth/sprite.frame.size.height;
                        sprite.yScale = tileHeight/sprite.frame.size.width;
                        sprite.position = CGPointMake(i * tileWidth + sprite.frame.size.width/2,
                                                      j * tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                        break;
                        
                    case JOIN_BASE:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:miniMapRedBaseImageName];
                        sprite.name = joinBaseSpriteName;
                        sprite.zRotation = 3 * M_PI / 2;
                        sprite.xScale = tileWidth/sprite.frame.size.height;
                        sprite.yScale = tileHeight/sprite.frame.size.width;
                        sprite.position = CGPointMake(i * tileWidth + sprite.frame.size.width/2,
                                                      j * tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                        break;
                        
                        // need to add an if visible clause
                    case CORAL:
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:coralImageName];
                        sprite.name = coralSpriteName;
                        sprite.zRotation = M_PI / 2;
                        sprite.xScale = tileWidth/sprite.frame.size.height;
                        sprite.yScale = tileHeight/sprite.frame.size.width;
                        sprite.position = CGPointMake(i * tileWidth + sprite.frame.size.width/2,
                                                      j * tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                        break;
                        
                    default:
                        break;
                        
                }
            }
        }
    }
}

// Scolls the background screens
- (void) scrollBackgrounds {
    SKNode* background1 = [_backgroundNode childNodeWithName:background1SpriteName];
    SKNode* background2 = [_backgroundNode childNodeWithName:background2SpriteName];
    
    background1.position = CGPointMake(background1.position.x-0.5, background1.position.y);
    background2.position = CGPointMake(background2.position.x-0.5,
                                       background2.position.y);
    
    if (background1.position.x < -background1.frame.size.width){
        background1.position = CGPointMake(background2.position.x + background2.frame.size.width,
                                           background1.position.y);
    }
    
    if (background2.position.x < -background2.frame.size.width) {
        background2.position = CGPointMake(background1.position.x + background1.frame.size.width,
                                           background2.position.y);
    }
}


@end
