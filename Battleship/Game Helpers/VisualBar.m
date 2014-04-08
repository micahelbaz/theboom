//
//  VisualBar.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "VisualBar.h"

@implementation VisualBar

- (instancetype) initVisualBarWithNode:(SKNode*) visualBarNode
                               andGame:(BattleshipGame*) game
                         andForeground:(Foreground*) foreground
                             andHelper:(Helpers*) helper{
    self = [super init];
    if (self) {
        _game = game;
        _visualBarNode = visualBarNode;
        _foreground = foreground;
        _helper = helper;
        [self initVisualBarSprite];
        _shipClickedName = [[SKNode alloc] init];
        _shipFunctions = [[SKNode alloc] init];
        _shipClicked = [[SKNode alloc] init];
        [_visualBarNode addChild:_shipClicked];
        [_visualBarNode addChild:_shipFunctions];
        [_visualBarNode addChild:_shipClickedName];
    }
    return self;
    
}

// Initializes the Visual Bar
- (void)initVisualBarSprite{
    SKSpriteNode* visualBar = [SKSpriteNode spriteNodeWithImageNamed:visualBarImageName];
    visualBar.name = visualBarNodeName;
    visualBar.xScale = visualBarWidth/visualBar.frame.size.width;
    visualBar.yScale = visualBarHeight/visualBar.frame.size.height;
    visualBar.position = CGPointMake(fullScreenWidth - visualBar.frame.size.width/2,
                                     visualBar.frame.size.height/2);
    [_visualBarNode addChild:visualBar];
}

// Displays the ship on the visual bar
- (void) displayShipDetails: (SKSpriteNode*) shipSprite {
    // Remove previous nodes
    [_shipFunctions removeAllChildren];
    [_shipClicked removeAllChildren];
    [_shipClickedName removeAllChildren];
    [_foreground.movementLocationsSprites removeAllChildren];
    
    _shipActuallyClicked = shipSprite;
    
    CGFloat positionFromTop = 20;
    
    positionFromTop = [self displayShipNameWithPositionFromTop:positionFromTop];
    positionFromTop = [self displayShipSpriteWithPositionFromTop:positionFromTop];
    positionFromTop = [self displayHealthBarWithPositionFromTop:positionFromTop];
    positionFromTop = [self displayValidMovesWithPositionFromTop:positionFromTop];
    
}

// Displays the ship name
- (float) displayShipNameWithPositionFromTop: (float) positionFromTop
{
    SKLabelNode *shipLabel = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
    [shipLabel setText:[self shipName:_shipActuallyClicked.name]];
    if([_shipActuallyClicked.name isEqualToString:@"JoinMineLayer1"] || [_shipActuallyClicked.name isEqualToString:@"JoinMineLayer2"] || [_shipActuallyClicked.name isEqualToString:@"HostMineLayer1"] || [_shipActuallyClicked.name isEqualToString:@"HostMineLayer2"]){
        NSLog(@"MINE LAYER");
        SKLabelNode *numMines = [SKLabelNode labelNodeWithFontNamed:@"displayedText"];
        int shipIndex = [_game getShipIndexWithName:_shipActuallyClicked.name];
        MineLayer *s = _game.localPlayer.playerFleet.shipArray[shipIndex];
        int numberMines = s.numMines;
        NSString *mineString = [NSString stringWithFormat:@"%d", numberMines];
        NSString *string = @"Mines: ";
        NSString *mineText = [NSString stringWithFormat:@"%@%@", string, mineString];
        [numMines setText:mineText];
        [numMines setFontSize:17];
        [numMines setFontName:@"28DaysLater"];
        [numMines setPosition:CGPointMake(fullScreenWidth - visualBarWidth/2,
                                          visualBarHeight - positionFromTop- 55)];
        [_shipClickedName addChild:numMines];
       
    }
    [shipLabel setFontSize:30];
    [shipLabel setFontName:@"28DaysLater"];
    positionFromTop += shipLabel.frame.size.height;
    [shipLabel setPosition:CGPointMake(fullScreenWidth - visualBarWidth/2,
                                       visualBarHeight - positionFromTop)];
    [_shipClickedName addChild:shipLabel];
    return positionFromTop;
}

// Displays the ship sprite
- (float) displayShipSpriteWithPositionFromTop:(float) positionFromTop
{
    NSMutableArray *shipDamages = [_game getShipDamages:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]];
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:_shipActuallyClicked.name];
    ship.name = _shipActuallyClicked.name;
    ship.yScale = positionFromTop/(CGFloat)ship.frame.size.height;
    ship.xScale = ((visualBarWidth/6)*[shipDamages count])/ship.frame.size.width;
    positionFromTop += ship.frame.size.height;
    ship.position = CGPointMake(fullScreenWidth - visualBarWidth/2,
                                visualBarHeight - positionFromTop);
    [_shipClicked addChild:ship];
    return positionFromTop;
}

// Displays the health bar
- (float) displayHealthBarWithPositionFromTop:(float) positionFromTop
{
    NSMutableArray *shipDamages = [_game getShipDamages:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]];
    SKSpriteNode *damage;
    NSNumber *armour;
    positionFromTop += [_shipClicked childNodeWithName:_shipActuallyClicked.name].frame.size.height;
    for (int i = 0; i < [shipDamages count]; i++)
    {
        armour = [shipDamages objectAtIndex:i];
        
        if ([armour intValue] == 0)
        {
            damage = [SKSpriteNode spriteNodeWithImageNamed:destroyedArmourImageName];
        }
        
        else if ([armour intValue] == 1)
        {
            damage = [SKSpriteNode spriteNodeWithImageNamed:normalArmourImageName];
        }
        
        else if ([armour intValue] == 2)
        {
            damage = [SKSpriteNode spriteNodeWithImageNamed:heavyArmourImageName];
        }
        
        damage.xScale = (([_shipClicked childNodeWithName:_shipActuallyClicked.name].frame.size.width)/[shipDamages count])/damage.frame.size.width;
        damage.yScale = 0.3;
        damage.position = CGPointMake(fullScreenWidth + (i * damage.frame.size.width)
                                      - visualBarWidth/2
                                      - (((((float)[shipDamages count]-1)/2) * damage.frame.size.width)),
                                      visualBarHeight - positionFromTop);
        [_shipClicked addChild:damage];
    }
    return positionFromTop;
}

// Displays the valid moves for this ship
- (float) displayValidMovesWithPositionFromTop:(float) positionFromTop
{
    // Gets the valid actions for this ship
    [_game getValidActionsFrom:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]];
    
    // Displays the valid actions on screen
    int i = 1;
    for (NSString *s in [_game getValidActionsFrom:[_helper fromTextureToCoordinate:_shipActuallyClicked.position]])
    {
        //NSLog(@"before setting: %f", positionFromTop);
        SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:s];
        positionFromTop += node.frame.size.height;
       // NSLog(@"after setting: %f", positionFromTop);
        node.position = CGPointMake(fullScreenWidth - visualBarWidth/2,
                                    visualBarHeight - positionFromTop);
        node.name = s;
        i++;
        [_shipFunctions addChild:node];
    }
    return positionFromTop;
}

// Detects which function is clicked
- (void) detectFunction:(SKNode*) functionSprite {
    
    // Displays the move areas available to this ship
    if ([functionSprite.name isEqual:moveImageName])
    {
        [_foreground displayMoveAreasForShip:_shipActuallyClicked];
    }
    // Displays the areas available to rotate for this ship
    else if ([functionSprite.name isEqual:rotateImageName])
    {
        
    }
    // Shoots a torpedo
    else if ([functionSprite.name isEqual:fireTorpedoImageName])
    {
        [_foreground createTorpedo:_shipActuallyClicked];
    }
    
    else if([functionSprite.name isEqualToString:@"FireCannon"] || [functionSprite.name isEqualToString:@"FireHeavyCannon"] ){
        [_foreground displayCannonRange:_shipActuallyClicked];
    }
    else if([functionSprite.name isEqualToString:@"DropMine"]){
        [_foreground displayMineRange:_shipActuallyClicked];
    }
    else if([functionSprite.name isEqualToString:@"PickupMine"]){
        [_foreground displayPickupMineRange:_shipActuallyClicked];
    }
    
    
}

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