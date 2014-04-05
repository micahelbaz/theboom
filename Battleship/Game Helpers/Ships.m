//
//  Ships.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Ships.h"

@implementation Ships

- (instancetype) initShipsWithNode:(SKNode*) shipsNode
                           andGame:(BattleshipGame*) game
                         andHelper:(Helpers*) helper
                      andVisualBar:(VisualBar*) visualBar
                     andForeground:(Foreground*) foreground
                        andMiniMap:(MiniMap*) miniMap
                        andConsole:(Console*) console{
    self = [super init];
    if (self) {
        _game = game;
        _shipsNode = shipsNode;
        _helper = helper;
        _visualBar = visualBar;
        _foreground = foreground;
        _miniMap = miniMap;
        _console = console;
        _movingShip = [[NSMutableArray alloc] init];
        _movingShipOldLocation = [[NSMutableArray alloc] init];
        _movingShipNewLocation = [[NSMutableArray alloc] init];
        _shipIntervals = MAX_SHIP_INTERVALS;
        _hostFleet = _game.localPlayer.playerFleet;
        [self initShipSprites];
    }
    return self;
}

// Initializes the Ships
- (void) initShipSprites {
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
                    
                    sprite = [SKSpriteNode spriteNodeWithImageNamed:s.shipName];
                    sprite.name = s.shipName;
                    sprite.yScale = tileWidth/sprite.frame.size.height;
                    sprite.xScale = (tileHeight * s.shipSize)/sprite.frame.size.width;
                    
                    if (s.location.direction == SOUTH) {
                        sprite.zRotation = -M_PI/2;
                    }
                    else if (s.location.direction == NORTH) {
                        sprite.zRotation = M_PI/2;
                    }
                    
                    sprite.position = [self positionShipSprite:sprite atCoordinate:s.location];
                    [_shipsNode addChild:sprite];
                }
            }
        }
    }
}

// Updates the ship location based on foreground node
- (void) updateShipLocation:(SKNode*) newShipLocation
{
    Coordinate* newLoc = [_helper fromTextureToCoordinate:newShipLocation.position];
    Ship *s = [_game.localPlayer.playerFleet getShipWithCoord:[ _helper fromTextureToCoordinate:_visualBar.shipActuallyClicked.position]];
    Coordinate* oldLoc =  s.location;
    newLoc.direction = oldLoc.direction;
    
    [_movingShip addObject:_visualBar.shipActuallyClicked];
    [_movingShipOldLocation addObject:oldLoc];
    [_movingShipNewLocation addObject:newLoc];
    
    [_visualBar.shipFunctions removeAllChildren];
    [_visualBar.shipClicked removeAllChildren];
    [_visualBar.shipClickedName removeAllChildren];
    [_foreground.movementLocationsSprites removeAllChildren];
    [_game moveShipfrom:oldLoc to:newLoc];
}

// Animates the ship movement - seems to work imperfectly
- (void) animateShips{
    
    //    for (int i = 0; i < [_hostFleet.shipArray count]; i++)
    //    {
    //        Ship* c = [_hostFleet.shipArray objectAtIndex:i];
    //        NSLog (@"First ship,%@",c.shipName);
    //    }
    //
    //    for (int i = 0; i < [_opponentFleet.shipArray count]; i++)
    //    {
    //        Ship* c = [_opponentFleet.shipArray objectAtIndex:i];
    //        NSLog (@"First ship,%@",c.shipName);
    //    }
    
    SKSpriteNode* ship = [_movingShip objectAtIndex:0];
    Coordinate* newCoord = [_movingShipNewLocation objectAtIndex:0];
    Coordinate* oldCoord = [_movingShipOldLocation objectAtIndex:0];
    int difference = newCoord.yCoord - oldCoord.yCoord;
    CGFloat translation = (CGFloat) difference * (MAX_SHIP_INTERVALS - (--_shipIntervals))/MAX_SHIP_INTERVALS;
    
    ship.position = CGPointMake((CGFloat)newCoord.xCoord * tileWidth + tileWidth/2,
                                ((CGFloat)oldCoord.yCoord) * tileHeight
                                + translation * tileHeight
                                - ship.frame.size.height/2 + tileHeight);
    
    [_miniMap animateMiniMapWithShip:ship andNewCoord:newCoord andOldCoord:oldCoord andIntervals:_shipIntervals];
    
    
    
    //return CGPointMake((double)c.xCoord * _sizes.tileWidth + _sizes.tileWidth/2 ,
    // (double)c.yCoord * _sizes.tileHeight - sprite.frame.size.height/2 + _sizes.tileHeight);
    
#pragma TOTALLY WRONG
    // Directions don't change as the rotations are unaffected
    if (_shipIntervals == 0)
    {
        // Check the direction of the coordinate
        if (newCoord.yCoord > oldCoord.yCoord)
        {
            [newCoord setDirection:NORTH];
        }
        else if (newCoord.yCoord < oldCoord.yCoord)
        {
            [newCoord setDirection:NORTH];
        }
        else if (newCoord.xCoord > oldCoord.xCoord)
        {
            [newCoord setDirection:NORTH];
        }
        else if (newCoord.xCoord < oldCoord.xCoord)
        {
            [newCoord setDirection:NORTH];
        }
        
        
        NSString *text = [NSString stringWithFormat:@"\n\nYour %@ moved from:\n(%d, %d) to (%d, %d).", [self shipName:ship.name], oldCoord.xCoord, oldCoord.yCoord, newCoord.xCoord, newCoord.yCoord];
        [_console setConsoleText:text];
        
        _shipIntervals = MAX_SHIP_INTERVALS;
        [_movingShip removeObjectAtIndex:0];
        [_movingShipNewLocation removeObjectAtIndex:0];
        [_movingShipOldLocation removeObjectAtIndex:0];
    }
}

-(CGPoint)positionShipSprite:(SKNode *)sprite atCoordinate:(Coordinate *)c {
    if ((int)sprite.zRotation == (int) M_PI/2) {
        return CGPointMake((double)c.xCoord * tileWidth + tileWidth/2 ,
                           (double)c.yCoord * tileHeight - sprite.frame.size.height/2 + tileHeight);
    }
    else if ((int)sprite.zRotation == (int) -M_PI/2) {
        return CGPointMake((double)c.xCoord * tileWidth + tileWidth/2 ,
                           (double)c.yCoord * tileHeight + sprite.frame.size.height/2);
    }
    // Not sure about these
    else if ((int) sprite.zRotation == (int) 0) {
        return CGPointMake((double)c.xCoord * tileWidth - sprite.frame.size.width/2 + tileWidth,
                           (double)c.yCoord * tileHeight + tileHeight/2);
    }
    else {
        return CGPointMake((double)c.xCoord * tileWidth + sprite.frame.size.width/2 + tileWidth,
                           (double)c.yCoord * tileHeight + tileHeight/2);
    }
}

// Changes the ship name to a representable string
-(NSString*) shipName: (NSString*) carbon{
    
    if ([[carbon substringToIndex:1] isEqualToString:@"HostC"])
    {
        return @"Cruiser";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"HostD"])
    {
        return @"Destroyer";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"HostT"])
    {
        return @"Torpedo Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"HostR"])
    {
        return @"Radar Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"HostM"])
    {
        return @"Mine Layer";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"JoinC"])
    {
        return @"Cruiser";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"JoinD"])
    {
        return @"Destroyer";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"JoinT"])
    {
        return @"Torpedo Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"JoinR"])
    {
        return @"Radar Boat";
    }
    
    else if ([[carbon substringToIndex:1] isEqualToString:@"JoinM"])
    {
        return @"Mine Layer";
    }
    
    return carbon;
}



@end