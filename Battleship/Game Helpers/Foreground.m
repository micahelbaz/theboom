//
//  Foreground.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Foreground.h"

@implementation Foreground

- (instancetype) initForegroundWithNode:(SKNode*) foregroundNode
                                andGame:(BattleshipGame*) game
                              andHelper:(Helpers*)helper
                             andConsole:(Console*)console{
    self = [super init];
    if (self) {
        _game = game;
        _foregroundNode = foregroundNode;
        _helper = helper;
        _console = console;
        _movementLocationsSprites = [[SKNode alloc] init];
        _torpedoSprites = [[SKNode alloc] init];
        _torpedoShot = [[NSMutableArray alloc] init];
        _torpedoShooter = [[NSMutableArray alloc] init];
        _torpedoIntervals = MAX_TORPEDO_INTERVALS;
        _canonRangeSprites = [[SKNode alloc] init];
        _mineRangeSprites = [[SKNode alloc]init];
        _selfDistructSprites = [[SKNode alloc] init];
        [_foregroundNode addChild:_canonRangeSprites];
        [_foregroundNode addChild:_movementLocationsSprites];
        [_foregroundNode addChild:_torpedoSprites];
        [_foregroundNode addChild:_mineRangeSprites];
        [_foregroundNode addChild:_selfDistructSprites];
    }
    return self;
}

// Displays the ship movements
- (void)displayMoveAreasForShip:(SKNode*)shipActuallyClicked
{
    
    [_movementLocationsSprites removeAllChildren];
    [_mineRangeSprites removeAllChildren];
    NSMutableArray* validMoves = [_game getValidMovesFrom:
                                  [_helper fromTextureToCoordinate:shipActuallyClicked.position]
                                       withRadarPositions:false];
    for (Coordinate* c in validMoves)
    {
        SKSpriteNode* range = [[SKSpriteNode alloc] initWithImageNamed:moveRangeImageName];
        range.xScale = (tileWidth/range.frame.size.width)*0.95;
        range.yScale = (tileHeight/range.frame.size.height)*0.95;
        range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                     c.yCoord * tileHeight + tileHeight/2);
        range.zPosition = 1;
        [_movementLocationsSprites addChild:range];
    }
    
}

- (void) displayCannonRange:(SKNode*)shipActuallyClicked{
    [_canonRangeSprites removeAllChildren];
    NSMutableArray* rangeCoordinates = [_game getCanonRange: [_helper fromTextureToCoordinate:shipActuallyClicked.position]];
    for(Coordinate *c in rangeCoordinates){
        SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
        range.xScale = (tileWidth/range.frame.size.width)*0.95;
        range.yScale = (tileHeight/range.frame.size.height)*0.95;
        range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                     c.yCoord * tileHeight + tileHeight/2);
        //range.zPosition = 1;
        [_canonRangeSprites addChild:range];
    }
}

- (void) displaySelfDistructRange:(SKNode*)shipActuallyClicked{
    [_selfDistructSprites removeAllChildren];
    NSMutableArray* rangeCoordinates = [_game getValidMovesFrom:[_helper fromTextureToCoordinate:shipActuallyClicked.position] withRadarPositions:FALSE];
    for(Coordinate *c in rangeCoordinates){
        SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
        range.xScale = (tileWidth/range.frame.size.width)*0.95;
        range.yScale = (tileHeight/range.frame.size.height)*0.95;
        range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                     c.yCoord * tileHeight + tileHeight/2);
        [_selfDistructSprites addChild:range];
    }
}

- (void) displayMineRange:(SKNode*)shipActuallyAclicked{
    [_mineRangeSprites removeAllChildren];
    Coordinate *shipLocation = [_game.localPlayer.playerFleet getShipWithCoord:[_helper fromTextureToCoordinate:shipActuallyAclicked.position]].location;
    if(shipLocation.direction == NORTH){
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = shipLocation.xCoord+1;
        rightOfShip1.yCoord = shipLocation.yCoord;
        rightOfShip2.xCoord = shipLocation.xCoord+1;
        rightOfShip2.yCoord = shipLocation.yCoord-1;
        leftOfShip1.xCoord = shipLocation.xCoord-1;
        leftOfShip1.yCoord = shipLocation.yCoord;
        leftOfShip2.xCoord = shipLocation.xCoord-1;
        leftOfShip2.yCoord = shipLocation.yCoord-1;
        aboveShip.yCoord = shipLocation.yCoord+1;
        aboveShip.xCoord = shipLocation.xCoord;
        belowShip.xCoord = shipLocation.xCoord;
        belowShip.yCoord = shipLocation.yCoord-2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        
        
        for(Coordinate *c in coordinates){
                if([c isWithinMap]){
                    if ([_game.gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                        Terrain terType = [_game.gameMap.grid[c.xCoord][c.yCoord] intValue];
                        if(terType == WATER){
                            SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
                            range.xScale = (tileWidth/range.frame.size.width)*0.95;
                            range.yScale = (tileHeight/range.frame.size.height)*0.95;
                            range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                                         c.yCoord * tileHeight + tileHeight/2);
                            range.zPosition = 1;

                            [_mineRangeSprites addChild:range];
                        }
                    }
                }
            }
        }

    else{
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = shipLocation.xCoord+1;
        rightOfShip1.yCoord = shipLocation.yCoord;
        rightOfShip2.xCoord = shipLocation.xCoord+1;
        rightOfShip2.yCoord = shipLocation.yCoord+1;
        leftOfShip1.xCoord = shipLocation.xCoord-1;
        leftOfShip1.yCoord = shipLocation.yCoord;
        leftOfShip2.xCoord = shipLocation.xCoord-1;
        leftOfShip2.yCoord = shipLocation.yCoord+1;
        aboveShip.yCoord = shipLocation.yCoord-1;
        aboveShip.xCoord = shipLocation.xCoord;
        belowShip.xCoord = shipLocation.xCoord;
        belowShip.yCoord = shipLocation.yCoord+2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        for(Coordinate *c in coordinates){
                if([c isWithinMap]){
                    if ([_game.gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                        Terrain terType = [_game.gameMap.grid[c.xCoord][c.yCoord] intValue];
                        if(terType == WATER){
                            SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
                            range.xScale = (tileWidth/range.frame.size.width)*0.95;
                            range.yScale = (tileHeight/range.frame.size.height)*0.95;
                            range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                                         c.yCoord * tileHeight + tileHeight/2);
                            range.zPosition = 1;
                            
                            [_mineRangeSprites addChild:range];
                        }
                    }
                }
            }
        }
}


- (void) displayPickupMineRange:(SKNode*)shipActuallyAclicked{
    [_pickupMineRangeSprites removeAllChildren];
    Coordinate *shipLocation = [_game.localPlayer.playerFleet getShipWithCoord:[_helper fromTextureToCoordinate:shipActuallyAclicked.position]].location;
    if(shipLocation.direction == NORTH){
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = shipLocation.xCoord+1;
        rightOfShip1.yCoord = shipLocation.yCoord;
        rightOfShip2.xCoord = shipLocation.xCoord+1;
        rightOfShip2.yCoord = shipLocation.yCoord-1;
        leftOfShip1.xCoord = shipLocation.xCoord-1;
        leftOfShip1.yCoord = shipLocation.yCoord;
        leftOfShip2.xCoord = shipLocation.xCoord-1;
        leftOfShip2.yCoord = shipLocation.yCoord-1;
        aboveShip.yCoord = shipLocation.yCoord+1;
        aboveShip.xCoord = shipLocation.xCoord;
        belowShip.xCoord = shipLocation.xCoord;
        belowShip.yCoord = shipLocation.yCoord-2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        
        
        for(Coordinate *c in coordinates){
            if([c isWithinMap]){
                if ([_game.gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    Terrain terType = [_game.gameMap.grid[c.xCoord][c.yCoord] intValue];
                    if(terType == MINE){
                        SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
                        range.xScale = (tileWidth/range.frame.size.width)*0.95;
                        range.yScale = (tileHeight/range.frame.size.height)*0.95;
                        range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                                     c.yCoord * tileHeight + tileHeight/2);
                        range.zPosition = 1;
                        
                        [_pickupMineRangeSprites addChild:range];
                    }
                }
            }
        }
    }
    
    else{
        Coordinate *rightOfShip1 = [[Coordinate alloc]init];
        Coordinate *rightOfShip2 = [[Coordinate alloc]init];
        Coordinate *leftOfShip1 = [[Coordinate alloc]init];
        Coordinate *leftOfShip2 = [[Coordinate alloc]init];
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        rightOfShip1.xCoord = shipLocation.xCoord+1;
        rightOfShip1.yCoord = shipLocation.yCoord;
        rightOfShip2.xCoord = shipLocation.xCoord+1;
        rightOfShip2.yCoord = shipLocation.yCoord+1;
        leftOfShip1.xCoord = shipLocation.xCoord-1;
        leftOfShip1.yCoord = shipLocation.yCoord;
        leftOfShip2.xCoord = shipLocation.xCoord-1;
        leftOfShip2.yCoord = shipLocation.yCoord+1;
        aboveShip.yCoord = shipLocation.yCoord-1;
        aboveShip.xCoord = shipLocation.xCoord;
        belowShip.xCoord = shipLocation.xCoord;
        belowShip.yCoord = shipLocation.yCoord+2;
        NSMutableArray *coordinates = [[NSMutableArray alloc]init];
        [coordinates addObject:leftOfShip1];
        [coordinates addObject:leftOfShip2];
        [coordinates addObject:rightOfShip1];
        [coordinates addObject:rightOfShip2];
        [coordinates addObject:aboveShip];
        [coordinates addObject:belowShip];
        for(Coordinate *c in coordinates){
            if([c isWithinMap]){
                if ([_game.gameMap.grid[c.xCoord][c.yCoord] isKindOfClass:[NSNumber class]]) {
                    Terrain terType = [_game.gameMap.grid[c.xCoord][c.yCoord] intValue];
                    if(terType == MINE){
                        SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
                        range.xScale = (tileWidth/range.frame.size.width)*0.95;
                        range.yScale = (tileHeight/range.frame.size.height)*0.95;
                        range.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
                                                     c.yCoord * tileHeight + tileHeight/2);
                        range.zPosition = 1;
                        
                        [_pickupMineRangeSprites addChild:range];
                    }
                }
            }
        }
    }
}

// Displays the torpedo
- (void) createTorpedo:(SKNode*)shipActuallyClicked
{
    [_movementLocationsSprites removeAllChildren];
    
    //Coordinate* impact = [_game fireTorpedo:[_helper fromTextureToCoordinate:shipActuallyClicked.position]];
    SKSpriteNode* torpedo = [[SKSpriteNode alloc] initWithImageNamed:torpedoImageName];
    torpedo.zRotation = -M_PI/2;
    torpedo.xScale = (tileWidth/torpedo.frame.size.height);
    torpedo.yScale = (tileHeight/torpedo.frame.size.width)*0.3;
    torpedo.position = CGPointMake([_helper fromTextureToCoordinate:shipActuallyClicked.position].xCoord * tileWidth + tileWidth/2,
                                 [_helper fromTextureToCoordinate:shipActuallyClicked.position].yCoord * tileHeight + tileHeight/2);
    //[_foregroundNode addChild:torpedo];
    [_torpedoShot addObject:torpedo];
    [_torpedoShooter addObject:shipActuallyClicked];
}
/*
// Animates the ship movement - seems to work imperfectly
- (void) animateTorpedo{
    SKSpriteNode* torpedo = [_torpedoShot objectAtIndex:0];
    SKNode* ship = [_torpedoShooter objectAtIndex:0];
    Coordinate* start = [_helper fromTextureToCoordinate:ship.position];
    Coordinate* impact = [_game fireTorpedo:start];
    int difference = impact.yCoord - start.yCoord;
    CGFloat translation = (CGFloat) difference * (MAX_TORPEDO_INTERVALS - (--_torpedoIntervals))/MAX_TORPEDO_INTERVALS;
    
    torpedo.position = CGPointMake((CGFloat)impact.xCoord * tileWidth + tileWidth/2,
                                ((CGFloat)start.yCoord) * tileHeight
                                + translation * tileHeight
                                - torpedo.frame.size.height/2 + tileHeight);
    
#pragma TOTALLY WRONG
    // Directions don't change as the rotations are unaffected
    if (_torpedoIntervals == 0)
    {
        NSString *text = [NSString stringWithFormat:@"\n\nYour %@ shot a torpedo which impacted at:\n(%d, %d).", [self shipName:ship.name], impact.xCoord, impact.yCoord];
        [_console setConsoleText:text];
        _torpedoIntervals = MAX_TORPEDO_INTERVALS;
        [torpedo removeFromParent];
        [_torpedoShot removeObjectAtIndex:0];
        [_torpedoShooter removeObjectAtIndex:0];
    }
}
*/
// Changes the ship name to a representable string
-(NSString*) shipName: (NSString*) carbon{
    
    if ([[carbon substringToIndex:1] isEqualToString:@"C"])
    {
        return @"Cruiser";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"D"])
    {
        return @"Destroyer";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"T"])
    {
        return @"Torpedo Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"R"])
    {
        return @"Radar Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"M"])
    {
        return @"Mine Layer";
    }
    
    return carbon;
}

@end
