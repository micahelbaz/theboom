//
//  MyScene.m
//  Battleship
//
//  Created by Rayyan Khoury on 1/30/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

typedef enum messageType {
    MAP,
    SHIP_LOCATION
}MessageType;

typedef struct {
    MessageType type;
    __unsafe_unretained NSData* packet;
}Message;

-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _game = [BattleshipGame sharedInstance];
        // Initializing the background - more time efficient as only loads the textures once
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _moveFromCoordinate = [[Coordinate alloc] initWithXCoordinate:0 YCoordinate:0 initiallyFacing:NONE];
        // Creates the battleship game
        _game.gameCenter.match.delegate = self;
        //if(_game.localPlayer.isHost) {
        //[self sendMap];
        [_game updateMap:_game.localPlayer.playerFleet];
        [_game updateMap:_game.localPlayer.enemyFleet];
        _mainGameController = [[MainGameController alloc] initMainGameControllerWithGame:_game andFrame:self.frame.size];
        [self addChild:_mainGameController.containers.overallNode];
        //[self drawRadar];
    }
    return self;
}

-(BOOL)sendMap {
    NSError* error;
    NSMutableArray* message = [[NSMutableArray alloc] init];
    [message addObject:[NSKeyedArchiver archivedDataWithRootObject:@"mapData"]];
    [message addObject:[NSKeyedArchiver archivedDataWithRootObject:_game.gameMap.grid]];
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:message];
    [_game.gameCenter.match sendDataToAllPlayers:packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(BOOL)sendFleetLocation {
    NSError* error;
    NSMutableArray* compactFleet = [[NSMutableArray alloc] init];
    [compactFleet addObject: [NSKeyedArchiver archivedDataWithRootObject:@"fleetData"]];
    for (Ship* s in _game.localPlayer.playerFleet.shipArray) {
        NSMutableArray* compactShip = [[NSMutableArray alloc] init];
        [compactShip addObject:[NSKeyedArchiver archivedDataWithRootObject:s.shipName]];
        [compactShip addObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:s.location.xCoord]]];
        [compactShip addObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:s.location.yCoord]]];
        [compactShip addObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:s.location.direction]]];
        [compactFleet addObject:[NSKeyedArchiver archivedDataWithRootObject: compactShip]];
    }
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:compactFleet];
    [_game.gameCenter.match sendDataToAllPlayers: packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(BOOL)sendMoveFromShipAtIndex: (int) i fromOrigin: (Coordinate*) c{
    NSError* error;
    NSMutableArray* shipMoveDetails = [[NSMutableArray alloc] init];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject:@"moveData"]];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:i]]];
    Ship* s = _game.localPlayer.playerFleet.shipArray[i];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:s.location.xCoord]]];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:s.location.yCoord]]];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:s.location.direction]]];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:c.xCoord]]];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:c.yCoord]]];
    [shipMoveDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:c.direction]]];
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:shipMoveDetails];
    [_game.gameCenter.match sendDataToAllPlayers: packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}




-(BOOL)sendTorpedoHit:(int) i{
    NSError* error;
    NSMutableArray* shipDetails = [[NSMutableArray alloc] init];
    [shipDetails addObject: [NSKeyedArchiver archivedDataWithRootObject:@"torpedoHitData"]];
    [shipDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:i]]];
    Ship* s = _game.localPlayer.enemyFleet.shipArray[i];
    NSMutableArray* shipDamages = [[NSMutableArray alloc] init];
    for (int j = 0; j < s.size; j++) {
        ShipSegment *seg = s.blocks[j];
        [shipDamages addObject:[NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:seg.segmentArmourType]]];
    }
    [shipDetails addObject:[NSKeyedArchiver archivedDataWithRootObject:shipDamages]];
    [shipDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:s.speed]]];
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:shipDetails];
    [_game.gameCenter.match sendDataToAllPlayers: packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(BOOL)sendRapairShip:(int) i{
    NSError* error;
    NSMutableArray* shipDetails = [[NSMutableArray alloc] init];
    [shipDetails addObject: [NSKeyedArchiver archivedDataWithRootObject:@"repairData"]];
    [shipDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:i]]];
    Ship* s = _game.localPlayer.enemyFleet.shipArray[i];
    NSMutableArray* shipDamages = [[NSMutableArray alloc] init];
    for (int j = 0; j < s.size; j++) {
        ShipSegment *seg = s.blocks[j];
        [shipDamages addObject:[NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:seg.segmentArmourType]]];
    }
    [shipDetails addObject:[NSKeyedArchiver archivedDataWithRootObject:shipDamages]];
    [shipDetails addObject: [NSKeyedArchiver archivedDataWithRootObject: [NSNumber numberWithInt:s.speed]]];
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:shipDetails];
    [_game.gameCenter.match sendDataToAllPlayers: packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;

}
-(void) match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"test");
    
    NSMutableArray* receivedMessage = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString* type = (NSString*) [NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[0]];
    if ([type isEqualToString:@"mapData"]) {
        
        _game.gameMap.grid = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[1]];
        
        [_game updateMap:_game.localPlayer.playerFleet];
        [_game updateMap:_game.localPlayer.enemyFleet];
        _mainGameController = [[MainGameController alloc] initMainGameControllerWithGame:_game andFrame:self.frame.size];
        [self addChild:_mainGameController.containers.overallNode];
        [self.view addSubview:_mainGameController.console.textView];
        //[self drawRadar];
    }
    else if ([type isEqualToString:@"fleetData"]) {
        Fleet *newFleet = [[Fleet alloc]init];
        for(int i=1; i<[receivedMessage count]; i++){
            Ship *s = newFleet.shipArray[i-1];
            NSMutableArray *shipsArray = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[i]];
            s.shipName = (NSString*)[NSKeyedUnarchiver unarchiveObjectWithData:shipsArray[0]];
            s.location.xCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: shipsArray[1]] intValue];
            s.location.yCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:shipsArray[2]] intValue];
            s.location.direction = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:shipsArray[3]] intValue];
        }
        [_game updateMap:newFleet];
        //[_mainGameController redrawShips];
    }
    
 
    else if([type isEqualToString:@"moveData"]){
        /* 1- NSNumber index of ship in flee
         2- NSnumber new x cord
         3- NSnumber new y cord
         4- NSnumber new direction   */
        
        Coordinate *newPosition = [[Coordinate alloc]init];
        Coordinate *oldPosition = [[Coordinate alloc]init];
        int shipIndex = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[1]] intValue];
        newPosition.xCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[2]] intValue];
        newPosition.yCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[3]] intValue];
        newPosition.direction = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[4]] intValue];
        oldPosition.xCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[5]] intValue];
        oldPosition.yCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[6]] intValue];
        oldPosition.direction = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[7]] intValue];
        NSArray *localShips = _game.localPlayer.enemyFleet.shipArray;
        Ship *s = localShips[shipIndex];
        [_mainGameController.ships.shipsNode childNodeWithName:s.shipName].position = [_mainGameController.ships positionShipSprite:[_mainGameController.ships.shipsNode childNodeWithName:s.shipName] atCoordinate:newPosition];
        [_game moveEnemyShipfrom:oldPosition to:newPosition];
    }
    else if([type isEqualToString:@"torpedoHitData"]){
        int hitIndex =[(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[1]] intValue];
        NSMutableArray *damageArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[2]];
        int newSpeed = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[3]] intValue];
        NSArray* localShips = _game.localPlayer.playerFleet.shipArray;
        Ship *s = localShips[hitIndex];
        s.speed = newSpeed;
        [s toggleRepairStatus:_game.localPlayer.playerFleet.dockingCoordinates];
        for(int i=0; i<s.size; i++){
            ShipSegment *seg = s.blocks[i];
            int currentDamage = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: damageArray[i]] intValue];
            seg.segmentArmourType = currentDamage;
            
        }
        if ([_game isShipDestroyed:s.shipName]) {
            [_mainGameController.ships removeShipFromScreen:s.shipName];
        }
        [s toggleRepairStatus:_game.localPlayer.playerFleet.dockingCoordinates];
    }
    else if([type isEqualToString:@"repairData"]){
        int hitIndex =[(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[1]] intValue];
        NSMutableArray *damageArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[2]];
        int newSpeed = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[3]] intValue];
        NSArray* localShips = _game.localPlayer.playerFleet.shipArray;
        Ship *s = localShips[hitIndex];
        s.speed = newSpeed;
        for(int i=0; i<s.size; i++){
            ShipSegment *seg = s.blocks[i];
            int currentDamage = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: damageArray[i]] intValue];
            seg.segmentArmourType = currentDamage;
            
        }
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        _nodeTouched = [self nodeAtPoint:location];
        
        // Mini map touched
        if ([_nodeTouched.name isEqualToString:miniMapSpriteName])
        {
            _mainGameController.miniMap.initiallyTouched = true;
        }
        
        // Background touched
        if ([_nodeTouched.parent isEqual:_mainGameController.gestures.gesturesNode]
            || [_nodeTouched.parent.parent isEqual:_mainGameController.gestures.gesturesNode])
        {
            _mainGameController.gestures.initiallyTouched = true;
        }
        
        // Ship touched
        if ([_nodeTouched.parent isEqual:_mainGameController.ships.shipsNode])
        {
            [_mainGameController.foreground.canonRangeSprites removeAllChildren];
            [_mainGameController.visualBar displayShipDetails:_nodeTouched];
            _shipIndex = [self getShipIndexFromName:_nodeTouched.name];
            Ship *s = _game.localPlayer.playerFleet.shipArray[_shipIndex];
            _moveFromCoordinate = s.location;
        }
        
        // Move button
        // Rotate button
        // Fire Torpedo button
        if ([_nodeTouched.parent isEqual:_mainGameController.visualBar.shipFunctions])
        {
            [_mainGameController.foreground.canonRangeSprites removeAllChildren];
            [_mainGameController.visualBar detectFunction:_nodeTouched];
            if ([_nodeTouched.name isEqualToString:@"FireTorpedo"]) {
                [_mainGameController.console setConsoleText:@"\n"];
                Ship *s = _game.localPlayer.playerFleet.shipArray[_shipIndex];
                Coordinate* impactCoord = [_game fireTorpedo:s.location];
                if ([_game.gameMap.grid[impactCoord.xCoord][impactCoord.yCoord] isKindOfClass:[NSNumber class]]) {
                    Terrain terType = [_game.gameMap.grid[impactCoord.xCoord][impactCoord.yCoord] intValue];
                    if (terType == CORAL) {
                        [_mainGameController.console setConsoleText:@"Coral Hit"];
                    }
                    else if (terType == WATER) {
                        [_mainGameController.console setConsoleText:@"Shot Fell into the Water"];
                    }
                    else {
                        [_mainGameController.console setConsoleText:@"Base Hit"];
                       
                    }
                }
                else {
                    ShipSegment *seg = (ShipSegment*) _game.gameMap.grid[impactCoord.xCoord][impactCoord.yCoord];
                    [_mainGameController.console setConsoleText:@"Ship Hit"];
                    [self sendTorpedoHit:[self getShipIndexFromName:seg.shipName]];
                    if ([_game isShipDestroyed:seg.shipName]) {
                        [_mainGameController.ships removeShipFromScreen:seg.shipName];
                    }
                }
            }
            if ([_nodeTouched.name isEqualToString:@"RepairShip"]) {
                Ship *s = _game.localPlayer.playerFleet.shipArray[_shipIndex];
                [s repair];
                [self sendRapairShip:[self getShipIndexFromName:s.shipName]];
            }
        }
        
        // Move location touched
        if ([_nodeTouched.parent isEqual:_mainGameController.foreground.movementLocationsSprites])
        {
            [_mainGameController.ships updateShipLocation:_nodeTouched];
            Ship *s = _game.localPlayer.playerFleet.shipArray[_shipIndex];
            [_mainGameController.ships.shipsNode childNodeWithName:s.shipName].position = [_mainGameController.ships positionShipSprite:[_mainGameController.ships.shipsNode childNodeWithName:s.shipName] atCoordinate:[_mainGameController.helper fromTextureToCoordinate:_nodeTouched.position]];
            [self sendMoveFromShipAtIndex:_shipIndex fromOrigin:_moveFromCoordinate];
            //[self drawRadar];
        }
        if ([_nodeTouched.parent isEqual:_mainGameController.foreground.canonRangeSprites]){
            [_mainGameController.foreground.canonRangeSprites removeAllChildren];
            Coordinate *squareTouched = [_mainGameController.helper fromTextureToCoordinate:_nodeTouched.position];
            [_game damageShipSegment:squareTouched];
            if([_game.gameMap.grid[squareTouched.xCoord][squareTouched.yCoord] isKindOfClass:[ShipSegment class]]){
                [_mainGameController.console setConsoleText:@"Ship Hit"];
                ShipSegment *seg = _game.gameMap.grid[squareTouched.xCoord][squareTouched.yCoord];
                [self sendTorpedoHit:[self getShipIndexFromName:seg.shipName]];
                if ([_game isShipDestroyed:seg.shipName]) {
                    [_mainGameController.ships removeShipFromScreen:seg.shipName];
                }
            }
        }
    }
}



-(int)getShipIndexFromName:(NSString*) shipName {
    int index = 0;
    for (Ship *s in _game.localPlayer.playerFleet.shipArray) {
        //NSLog(@"%@", s.shipName);
        if ([shipName isEqualToString:s.shipName]) {
            //NSLog(@"%d", index);
            return index;
        }
        index++;
    }
    index = 0;
    
    for (Ship *s in _game.localPlayer.enemyFleet.shipArray) {
        //NSLog(@"%@", s.shipName);
        if ([shipName isEqualToString:s.shipName]) {
            //NSLog(@"%d", index);
            return index;
        }
        index++;
    }
    return -1;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    
    // Move mini map
    if (_mainGameController.miniMap.initiallyTouched)
    {
        [_mainGameController.miniMap updateMiniMapPositionWithTranslation:translation];
    }
    
    // Move map around
    if (_mainGameController.gestures.initiallyTouched && !_mainGameController.miniMap.initiallyTouched)
    {
        [_mainGameController.gestures updateGesturesPositionWithTranslation:translation];
    }
}

// Called when the finger is removed
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // Relocate mini map
    if(_mainGameController.miniMap.initiallyTouched)
    {
        [_mainGameController.miniMap setMiniMapLocation:location];
        _mainGameController.miniMap.initiallyTouched = false;
    }
    
    // Update background
    if(_mainGameController.gestures.initiallyTouched)
    {
        _mainGameController.gestures.initiallyTouched = false;
    }
    
}

-(void)drawRadar{
    NSMutableArray *shipsToBeRemoved = [[NSMutableArray alloc] init];
    for (SKSpriteNode *child in self.children) {
        if ([child.name isEqualToString:@"radar"]) {
            [shipsToBeRemoved addObject:child];
        }
    }
    [self removeChildrenInArray:shipsToBeRemoved];
    [_game.localPlayer updateRadarRange];
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            if ([_game.gameMap.grid[i][j] isKindOfClass:[NSNumber class]]) {
                Terrain ter = [_game.gameMap.grid[i][j] intValue];
                if (ter == CORAL || ter == HOST_BASE || ter == JOIN_BASE) {
                    //NSLog(@"%d,%d", i,j);
                    [_game.localPlayer.radarGrid[i] removeObjectAtIndex:j];
                    [_game.localPlayer.radarGrid[i] insertObject:[NSNumber numberWithBool:YES] atIndex:j];
                }
            }
        }
    }
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
                [self addChild:sprite];
            }
        }
    }
}
//    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:miniMapImageName];
//    sprite.yScale = tileWidth/sprite.frame.size.height;
//    sprite.xScale = tileHeight/sprite.frame.size.width;
//    sprite.position = CGPointMake(c.xCoord * tileWidth + tileWidth/2,
//                                  (c.yCoord) * tileHeight
//                                  - sprite.frame.size.height/2 + tileHeight);
//    [_radarNode addChild:sprite];

/*
 -(void)update:(CFTimeInterval)currentTime {
 // Scrolls the backgrounds according to current time
 //[_mainGameController.background scrollBackgrounds];
 
 // Ships to move
 if ([_mainGameController.ships.movingShip count] > 0)
 {
 [_mainGameController.ships animateShips];
 }
 
 // Ships to move
 if ([_mainGameController.foreground.torpedoShot count] > 0)
 {
 [_mainGameController.foreground animateTorpedo];
 }
 }
 */
// Handles the pinch
-(void) handlePinch:(UIPinchGestureRecognizer *) recognizer {
    
    [_mainGameController.gestures handlePinchWithRecognizerScale:recognizer.scale];
}

// Adds the pinch recognizer to the scene
- (void)didMoveToView:(SKView *)view{
    // Sets the pinch recognizer
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector (handlePinch:)];
    [[self view] addGestureRecognizer:_pinchRecognizer];
    
    // Adds the console box
    [self.view addSubview:_mainGameController.console.textView];
}
@end