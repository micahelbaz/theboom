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
        [_foregroundNode addChild:_canonRangeSprites];
        [_foregroundNode addChild:_movementLocationsSprites];
        [_foregroundNode addChild:_torpedoSprites];
        [_foregroundNode addChild:_mineRangeSprites];
    }
    return self;
}

// Displays the ship movements
- (void)displayMoveAreasForShip:(SKNode*)shipActuallyClicked
{
    [_movementLocationsSprites removeAllChildren];
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

- (void) displayMineRange:(SKNode*)shipActuallyAclicked{
    Coordinate *shipLocation = [_helper fromTextureToCoordinate:shipActuallyAclicked.position];
    if(shipLocation.direction == NORTH){
        int xRange = shipLocation.xCoord-1;
        int yRange = shipLocation.yCoord-1;
        for(int i = xRange; i < xRange+3; i++){
            for(int j = yRange; j<yRange+3; j++){
                Coordinate *c = [[Coordinate alloc]init];
                c.xCoord = i;
                c.yCoord = j;
                c.direction = NORTH;
                if([c isWithinMap]){
                    if ([_game.gameMap.grid[i][j] isKindOfClass:[NSNumber class]]) {
                        Terrain terType = [_game.gameMap.grid[i][j] intValue];
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
        Coordinate *aboveShip = [[Coordinate alloc]init];
        Coordinate *belowShip = [[Coordinate alloc]init];
        belowShip.xCoord = shipLocation.xCoord;
        aboveShip.xCoord = shipLocation.xCoord;
        aboveShip.yCoord = shipLocation.yCoord+1;
        belowShip.yCoord = shipLocation.yCoord-2;
        belowShip.direction = NORTH;
        aboveShip.direction = NORTH;
        NSMutableArray *coords = [[NSMutableArray alloc]init];
        [coords addObject:aboveShip];
        [coords addObject:belowShip];
        for(Coordinate *coord in coords){
            if([coord isWithinMap]){
                if ([_game.gameMap.grid[coord.xCoord][coord.yCoord] isKindOfClass:[NSNumber class]]) {
                    Terrain terType = [_game.gameMap.grid[coord.xCoord][coord.yCoord] intValue];
                    if(terType == WATER){
                        SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
                        range.xScale = (tileWidth/range.frame.size.width)*0.95;
                        range.yScale = (tileHeight/range.frame.size.height)*0.95;
                        range.position = CGPointMake(coord.xCoord * tileWidth + tileWidth/2,
                                                     coord.yCoord * tileHeight + tileHeight/2);
                        range.zPosition = 1;
                        [_mineRangeSprites addChild:range];
                    }
                }
            }

        }
    }
    else{
        int xRange = shipLocation.xCoord-1;
        int yRange = shipLocation.yCoord;
        for(int i = xRange; i < xRange+3; i++){
            for(int j = yRange; j<yRange+2; j++){
                Coordinate *c = [[Coordinate alloc]init];
                c.xCoord = i;
                c.yCoord = j;
                c.direction = SOUTH;
                if([c isWithinMap]){
                    if ([_game.gameMap.grid[i][j] isKindOfClass:[NSNumber class]]) {
                        Terrain terType = [_game.gameMap.grid[i][j] intValue];
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
    Coordinate *aboveShip = [[Coordinate alloc]init];
    Coordinate *belowShip = [[Coordinate alloc]init];
    belowShip.xCoord = shipLocation.xCoord;
    aboveShip.xCoord = shipLocation.xCoord;
    aboveShip.yCoord = shipLocation.yCoord-1;
    belowShip.yCoord = shipLocation.yCoord+2;
    belowShip.direction = NORTH;
    aboveShip.direction = NORTH;
    NSMutableArray *coords = [[NSMutableArray alloc]init];
    [coords addObject:aboveShip];
    [coords addObject:belowShip];
    for(Coordinate *coord in coords){
        if([coord isWithinMap]){
            if ([_game.gameMap.grid[coord.xCoord][coord.yCoord] isKindOfClass:[NSNumber class]]) {
                Terrain terType = [_game.gameMap.grid[coord.xCoord][coord.yCoord] intValue];
                if(terType == WATER){
                    SKSpriteNode* range = [[SKSpriteNode alloc]initWithImageNamed:moveRangeImageName];
                    range.xScale = (tileWidth/range.frame.size.width)*0.95;
                    range.yScale = (tileHeight/range.frame.size.height)*0.95;
                    range.position = CGPointMake(coord.xCoord * tileWidth + tileWidth/2,
                                                 coord.yCoord * tileHeight + tileHeight/2);
                    range.zPosition = 1;
                    [_mineRangeSprites addChild:range];
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
