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
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:miniMapGreenBaseImageName];
                        NSMutableString *name = [[NSMutableString alloc] init];
                        [name appendString:@"hostbase"];
                        NSString *string = [name stringByAppendingFormat:@"%i", i];
                        sprite.name = string;
                        sprite.zRotation =  M_PI / 2;
                        sprite.xScale = tileWidth/sprite.frame.size.height;
                        sprite.yScale = tileHeight/sprite.frame.size.width;
                        sprite.position = CGPointMake(i * tileWidth + sprite.frame.size.width/2,
                                                      j * tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                    }
                        break;
                    case JOIN_BASE:
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:miniMapRedBaseImageName];
                        NSMutableString *name = [[NSMutableString alloc] init];
                        [name appendString:@"joinbase"];
                        NSString *string = [name stringByAppendingFormat:@"%i", i];
                        sprite.name = string;
                        sprite.zRotation = 3 * M_PI / 2;
                        sprite.xScale = tileWidth/sprite.frame.size.height;
                        sprite.yScale = tileHeight/sprite.frame.size.width;
                        sprite.position = CGPointMake(i * tileWidth + sprite.frame.size.width/2,
                                                      j * tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                    }
                        break;
                        
                        // need to add an if visible clause
                    case CORAL:
                    {
                        sprite = [SKSpriteNode spriteNodeWithImageNamed:coralImageName];
                        sprite.name = coralSpriteName;
                        sprite.zRotation = M_PI / 2;
                        sprite.xScale = tileWidth/sprite.frame.size.height;
                        sprite.yScale = tileHeight/sprite.frame.size.width;
                        sprite.position = CGPointMake(i * tileWidth + sprite.frame.size.width/2,
                                                      j * tileHeight + sprite.frame.size.height/2);
                        [_backgroundNode addChild:sprite];
                    }
                        break;
                        
                    default:
                        break;
                        
                }
            }
        }
    }
}
-(void)removeBaseFromScreen:(int)xCoord and:(int)yCoord {
    NSLog(@"base to be deleted %d , %d", xCoord, yCoord);
    NSString *name = [[NSString alloc] init];
    NSMutableString *tempString = [[NSMutableString alloc] init];
    if (yCoord == 0) {
        [tempString appendString:@"hostbase"];
        name = [tempString stringByAppendingFormat:@"%i", xCoord];
    }
    else {
        [tempString appendString:@"joinbase"];
        name = [tempString stringByAppendingFormat:@"%i", xCoord];
    }
    NSMutableArray* shipToBeRemoved = [[NSMutableArray alloc] init];
    for (SKSpriteNode *child in _backgroundNode.children) {
        if ([child.name isEqualToString:name]) {
            [shipToBeRemoved addObject:child];
        }
    }
    [_backgroundNode removeChildrenInArray:shipToBeRemoved];
}

-(void) addMine:(Coordinate *) mineLocation{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"mine"];
    
    NSMutableString *name = [[NSMutableString alloc]init];
    [name appendFormat:@"%@", @"mine"];
    [name appendFormat:@"%i", mineLocation.xCoord];
    [name appendFormat:@"%@", @"y"];
    [name appendFormat:@"%i", mineLocation.yCoord];
                             
    sprite.name = name;
    sprite.zRotation =  M_PI / 2;
    sprite.xScale = tileWidth/sprite.frame.size.height;
    sprite.yScale = tileHeight/sprite.frame.size.width;
    sprite.position = CGPointMake(mineLocation.xCoord * tileWidth + sprite.frame.size.width/2,
                                  mineLocation.yCoord * tileHeight + sprite.frame.size.height/2);
    [_backgroundNode addChild:sprite];
//    NSMutableString *string = (NSMutableString*)[name stringByAppendingFormat:@"%i", mineLocation.xCoord];
//    [name appendString:@"y"];
    
    
}

-(void)removeMine:(Coordinate*) mineLocation{
    NSMutableArray *child = [[NSMutableArray alloc]init];
   
    for(SKNode *n in _backgroundNode.children){
        if([[n.name substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"mine"]){
            if((mineLocation.xCoord/10)>0){
                if([[n.name substringWithRange:NSMakeRange(4, 2)] isEqualToString:[NSString stringWithFormat:@"%i", mineLocation.xCoord]]){
                    if(mineLocation.yCoord/10>0){
                        if([[n.name substringWithRange:NSMakeRange(7, 2)] isEqualToString:[NSString stringWithFormat:@"%i", mineLocation.yCoord]]){
                            [child addObject:n];
                            [_backgroundNode removeChildrenInArray:child];
                        }
                    }
                    else{
                        if([[n.name substringWithRange:NSMakeRange(7, 1)] isEqualToString:[NSString stringWithFormat:@"%i", mineLocation.yCoord]]){
                            [child addObject:n];
                            [_backgroundNode removeChildrenInArray:child];
                        }
                    }
                }
            }
            else{
                if([[n.name substringWithRange:NSMakeRange(4, 1)] isEqualToString:[NSString stringWithFormat:@"%i", mineLocation.xCoord]]){
                    if(mineLocation.yCoord/10>0){
                        if([[n.name substringWithRange:NSMakeRange(6, 2)] isEqualToString:[NSString stringWithFormat:@"%i", mineLocation.yCoord]]){
                            [child addObject:n];
                            [_backgroundNode removeChildrenInArray:child];
                        }
                    }
                    else{
                        if([[n.name substringWithRange:NSMakeRange(6, 1)] isEqualToString:[NSString stringWithFormat:@"%i", mineLocation.yCoord]]){
                            [child addObject:n];
                            [_backgroundNode removeChildrenInArray:child];
                        }
                    }
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
-(void)drawRadarToMap:(NSMutableArray *)grid {
    NSMutableArray *removed = [[NSMutableArray alloc] init];
    for (SKSpriteNode *s in _backgroundNode.children) {
        if([s.name isEqualToString:@"radar"]) {
            [removed addObject:s];
        }
    }
    [_backgroundNode removeChildrenInArray:removed];
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            if ([_game.localPlayer.radarGrid[i][j] intValue] == 0) {
                SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
                sprite = [SKSpriteNode spriteNodeWithImageNamed:@"black"];
                sprite.name = @"radar";
                sprite.xScale = tileWidth/sprite.frame.size.width;
                sprite.yScale = tileHeight/sprite.frame.size.height;
                sprite.position = CGPointMake(i * tileWidth + tileWidth/2,
                                              j * tileHeight + tileWidth/2);
                sprite.zPosition = 1;
                [_backgroundNode addChild:sprite];
            }
        }
    }
}

@end
