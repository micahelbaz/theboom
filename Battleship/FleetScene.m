//
//  FleetScene.m
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-25.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "FleetScene.h"

@implementation FleetScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _game = [BattleshipGame sharedInstance];
        _game.gameCenter.match.delegate = self;
        _fleetBackground = [[SKSpriteNode alloc] init];
        _unplacedShips = [[NSMutableArray alloc] init];
        _placedShip = [[NSMutableArray alloc] init];
        _lastIndex = -1;
        _configurationSet = FALSE;
        _youReady = FALSE;
        _opponentReady = FALSE;
        SKTexture *textureImage = [SKTexture textureWithImageNamed:@"menu background"];
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite = [SKSpriteNode spriteNodeWithTexture:textureImage];
        backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundSprite.xScale = 0.6;
        backgroundSprite.yScale = 0.6;
        _fleetBackground = [SKSpriteNode spriteNodeWithImageNamed:@"black"];
        _fleetBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _fleetBackground.xScale = self.frame.size.width *24/_fleetBackground.frame.size.width/30;
        _fleetBackground.yScale = self.frame.size.height * 10/_fleetBackground.frame.size.height/30;
        [self addChild:backgroundSprite];
        [self addChild:_fleetBackground];
        if(_game.localPlayer.isHost) {
            [self addHostButtons];
            [self initializeCoral];
        }
        [self initializeFleet];
    }
    return self;
}

-(void) initializeFleet {
    [_unplacedShips addObject:@"c1"];
    [_unplacedShips addObject:@"c2"];
    [_unplacedShips addObject:@"d1"];
    [_unplacedShips addObject:@"d2"];
    [_unplacedShips addObject:@"d3"];
    [_unplacedShips addObject:@"t1"];
    [_unplacedShips addObject:@"t2"];
    [_unplacedShips addObject:@"m1"];
    [_unplacedShips addObject:@"m2"];
    [_unplacedShips addObject:@"r1"];
    for (int i = 0; i < 10; i++) {
        [_placedShip addObject:[NSNumber numberWithInt:-1]];
        SKSpriteNode *base = [SKSpriteNode spriteNodeWithImageNamed:@"NormalArmour"];
        base.xScale = _fleetBackground.frame.size.width/24/base.frame.size.width;
        base.yScale = _fleetBackground.frame.size.height/10/base.frame.size.height;
        base.position = CGPointMake(CGRectGetMinX(self.frame)+base.frame.size.width/2+ base.frame.size.width*(i+10), CGRectGetMinY(self.frame) + base.frame.size.height/2);
        NSMutableString *name = [[NSMutableString alloc] init];
        [name appendString:@"base"];
        base.name = [name stringByAppendingFormat:@"%i", i];
        [self addChild:base];
    }
}

-(void) addHostButtons {
    SKSpriteNode *nextconfig = [SKSpriteNode spriteNodeWithImageNamed:@"reefconfig"];
    nextconfig.position = CGPointMake(CGRectGetMinX(_fleetBackground.frame)+ nextconfig.frame.size.width/2, (CGRectGetMaxY(_fleetBackground.frame)+CGRectGetMaxY(self.frame))/2);
    nextconfig.name = @"next configuration";
    [self addChild:nextconfig];
    SKSpriteNode *sendconfig = [SKSpriteNode spriteNodeWithImageNamed:@"send reef request"];
    sendconfig.position = CGPointMake(CGRectGetMaxX(_fleetBackground.frame)- sendconfig.frame.size.width/2, (CGRectGetMaxY(_fleetBackground.frame)+CGRectGetMaxY(self.frame))/2);
    sendconfig.name = @"send configuration";
    [self addChild:sendconfig];
}

-(void) addJoinButtons {
    SKSpriteNode *acceptconfig = [SKSpriteNode spriteNodeWithImageNamed:@"accept reef request"];
    acceptconfig.position = CGPointMake(CGRectGetMinX(_fleetBackground.frame)+ acceptconfig.frame.size.width/2, (CGRectGetMaxY(_fleetBackground.frame)+CGRectGetMaxY(self.frame))/2);
    acceptconfig.name = @"accept configuration";
    [self addChild:acceptconfig];
    SKSpriteNode *rejectconfig = [SKSpriteNode spriteNodeWithImageNamed:@"rejectconfig"];
    rejectconfig.position = CGPointMake(CGRectGetMaxX(_fleetBackground.frame)- rejectconfig.frame.size.width/2, (CGRectGetMaxY(_fleetBackground.frame)+CGRectGetMaxY(self.frame))/2);
    rejectconfig.name = @"reject configuration";
    [self addChild:rejectconfig];
}

-(void) initializeCoral {
    [self generateCoral];
    [self addCoral];
}

-(void) addCoral {
    for (Coordinate *c in _coralPositions) {
        SKSpriteNode *coral = [SKSpriteNode spriteNodeWithImageNamed:@"corals"];
        coral.name = @"coral";
        coral.xScale = _fleetBackground.frame.size.width/24/coral.frame.size.width;
        coral.yScale = _fleetBackground.frame.size.height/10/coral.frame.size.height;
        coral.position = CGPointMake(CGRectGetMinX(_fleetBackground.frame) + coral.frame.size.width/2 + c.xCoord * _fleetBackground.frame.size.width/24, CGRectGetMinY(_fleetBackground.frame) + coral.frame.size.height/2 + c.yCoord * _fleetBackground.frame.size.height/10);
        [self addChild:coral];
    }
}

-(void) generateCoral {
    _coralPositions = [[NSMutableSet alloc] init];
    while ([_coralPositions count] < 24)    {
        int yCoord = arc4random_uniform(10);
        int xCoord = arc4random_uniform(24);
        int breakFlag = 0;
        Coordinate *c = [[Coordinate alloc]initWithXCoordinate:xCoord YCoordinate:yCoord initiallyFacing:NONE];
        for (Coordinate *contained in _coralPositions) {
            if (contained.xCoord == c.xCoord && contained.yCoord == c.yCoord) {
                breakFlag = 1;
                continue;
            }
        }
        if (breakFlag == 1) {
            continue;
        }
        [_coralPositions addObject:c];
    }
}

-(BOOL)sendCoral {
    NSError* error;
    NSMutableArray* message = [[NSMutableArray alloc] init];
    [message addObject:[NSKeyedArchiver archivedDataWithRootObject:@"coralData"]];
    for (Coordinate* c in _coralPositions) {
       [message addObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:c.xCoord]]];
        [message addObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:c.yCoord]]];
        NSLog(@"%d %d", c.xCoord, c.yCoord);
    }
    
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:message];
    [_game.gameCenter.match sendDataToAllPlayers:packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(BOOL)sendResponse:(BOOL) doesAccept {
    NSError* error;
    NSMutableArray* message = [[NSMutableArray alloc] init];
    if (doesAccept) {
        [message addObject:[NSKeyedArchiver archivedDataWithRootObject:@"acceptCoralRequest"]];
    }
    else {
        [message addObject:[NSKeyedArchiver archivedDataWithRootObject:@"rejectCoralRequest"]];
    }
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:message];
    [_game.gameCenter.match sendDataToAllPlayers:packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(BOOL)sendBegin {
    NSError* error;
    NSMutableArray* message = [[NSMutableArray alloc] init];
    [message addObject:[NSKeyedArchiver archivedDataWithRootObject:@"begin"]];
    for (int i = 0; i < _placedShip.count; i++) {
        [message addObject:[NSKeyedArchiver archivedDataWithRootObject:_placedShip[i]]];
    }
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:message];
    [_game.gameCenter.match sendDataToAllPlayers:packet withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"error");
    }
    return false;
}

-(void) match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    NSMutableArray* receivedMessage = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString* type = (NSString*) [NSKeyedUnarchiver unarchiveObjectWithData:receivedMessage[0]];
    NSLog(@"%@", type);
    if ([type isEqualToString:@"coralData"]) {
        _coralPositions = [[NSMutableSet alloc] init];
        for (int i=1; i < receivedMessage.count; i+=2) {
            Coordinate *c = [[Coordinate alloc] init];
            c.xCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[i]] intValue];
            c.yCoord = [(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[i+1]] intValue];
            NSLog(@"%d %d", c.xCoord, c.yCoord);
            [_coralPositions addObject:c];
        }
        NSMutableArray *remove = [[NSMutableArray alloc] init];
        for (SKSpriteNode *button in self.children) {
            if ([button.name isEqualToString:@"accept configuration"] || [button.name isEqualToString:@"reject configuration"]) {
                [remove addObject:button];
            }
        }
        [self removeChildrenInArray:remove];
        NSMutableArray *corals = [[NSMutableArray alloc] init];
        for (SKSpriteNode *coral in self.children) {
            if ([coral.name isEqualToString:@"coral"]) {
                [corals addObject:coral];
            }
        }
        [self removeChildrenInArray:corals];
        [self addCoral];
        [self addJoinButtons];
    }
    if ([type isEqualToString:@"rejectCoralRequest"]) {
        [self addHostButtons];
    }
    if ([type isEqualToString:@"acceptCoralRequest"]) {
        _configurationSet = TRUE;
        [_game.gameMap initializeCoral:_coralPositions];
    }
    if ([type isEqualToString:@"begin"]) {
        _opponentReady = TRUE;
        NSMutableArray *enemyShips = [[NSMutableArray alloc] init];
        for (int i=1; i < receivedMessage.count; i++) {
            [enemyShips addObject:(NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData: receivedMessage[i]]];
        }
        if (_opponentReady && _youReady) {
            SKScene * scene = [MyScene sceneWithSize:self.scene.view.bounds.size];
            [self.scene.view presentScene:scene];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        SKNode *nodeTouched = [self nodeAtPoint:location];
        if ([nodeTouched.name isEqualToString:@"next configuration"]) {
            NSMutableArray *corals = [[NSMutableArray alloc] init];
            for (SKSpriteNode *coral in self.children) {
                if ([coral.name isEqualToString:@"coral"]) {
                    [corals addObject:coral];
                }
            }
            [self removeChildrenInArray:corals];
            [self initializeCoral];
        }
        if ([nodeTouched.name isEqualToString:@"accept configuration"]) {
            NSMutableArray *remove = [[NSMutableArray alloc] init];
            for (SKSpriteNode *button in self.children) {
                if ([button.name isEqualToString:@"accept configuration"] || [button.name isEqualToString:@"reject configuration"]) {
                    [remove addObject:button];
                }
            }
            [self removeChildrenInArray:remove];
            _configurationSet = TRUE;
            [self sendResponse:TRUE];
            [_game.gameMap initializeCoral:_coralPositions];
        }
        if ([nodeTouched.name isEqualToString:@"reject configuration"]) {
            NSMutableArray *remove = [[NSMutableArray alloc] init];
            for (SKSpriteNode *button in self.children) {
                if ([button.name isEqualToString:@"accept configuration"] || [button.name isEqualToString:@"reject configuration"]) {
                    [remove addObject:button];
                }
            }
            [self removeChildrenInArray:remove];
            [self sendResponse:FALSE];
        }
        if ([nodeTouched.name isEqualToString:@"send configuration"]) {
            NSMutableArray *remove = [[NSMutableArray alloc] init];
            for (SKSpriteNode *button in self.children) {
                if ([button.name isEqualToString:@"next configuration"] || [button.name isEqualToString:@"send configuration"]) {
                    [remove addObject:button];
                }
            }
            [self removeChildrenInArray:remove];
            [self sendCoral];
        }
        if ([nodeTouched.name isEqualToString:@"begingame"]) {
            _youReady = TRUE;
            if (_opponentReady && _youReady) {
                SKScene * scene = [MyScene sceneWithSize:self.scene.view.bounds.size];
                [self.scene.view presentScene:scene];
            }
        }
        else if ([[nodeTouched.name substringToIndex:4] isEqualToString:@"base"] && _configurationSet){
            int index = [[nodeTouched.name substringFromIndex:4] intValue];
            [self placeNextShipAtIndex:index];
            _lastIndex = index;
            BOOL flag = TRUE;
            for (int i = 0; i < _placedShip.count; i++) {
                if ([_placedShip[i] intValue] == -1 ) {
                    flag = FALSE;
                }
            }
            if (flag) {
                SKSpriteNode *start = [SKSpriteNode spriteNodeWithImageNamed:@"begingame"];
                start.position = CGPointMake(CGRectGetMidX(_fleetBackground.frame), (CGRectGetMaxY(_fleetBackground.frame)+CGRectGetMaxY(self.frame))/2);
                start.name = @"start game";
                [self addChild:start];
                _game.localPlayer.playerFleet = [[Fleet alloc] initWith:TRUE andShips:_placedShip];
            }
        }
    }
}


-(void) placeNextShipAtIndex: (int) index {
    NSMutableArray *removeShip = [[NSMutableArray alloc] init];
    for (SKSpriteNode* child in self.children) {
        if ([child.name isEqualToString:[NSString stringWithFormat:@"%i", index]]) {
            [removeShip addObject:child];
        }
    }
    [self removeChildrenInArray:removeShip];
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    [sizes addObject:[NSNumber numberWithInt:5]];
    [sizes addObject:[NSNumber numberWithInt:5]];
    [sizes addObject:[NSNumber numberWithInt:4]];
    [sizes addObject:[NSNumber numberWithInt:4]];
    [sizes addObject:[NSNumber numberWithInt:4]];
    [sizes addObject:[NSNumber numberWithInt:3]];
    [sizes addObject:[NSNumber numberWithInt:3]];
    [sizes addObject:[NSNumber numberWithInt:2]];
    [sizes addObject:[NSNumber numberWithInt:2]];
    [sizes addObject:[NSNumber numberWithInt:3]];
    
    int currentShip = [_placedShip[index] intValue];
    if (currentShip != -1) {
        switch (currentShip) {
            case 0: _unplacedShips[0] = @"c1";
                break;
            case 1: _unplacedShips[1] = @"c2";
                break;
            case 2: _unplacedShips[2] = @"d1";
                break;
            case 3: _unplacedShips[3] = @"d2";
                break;
            case 4: _unplacedShips[4] = @"d3";
                break;
            case 5: _unplacedShips[5] = @"t1";
                break;
            case 6: _unplacedShips[6] = @"t2";
                break;
            case 7: _unplacedShips[7] = @"m1";
                break;
            case 8: _unplacedShips[8] = @"m2";
                break;
            case 9: _unplacedShips[9] = @"r1";
                break;
            default: break;
        }
    }
    int shipIndex = currentShip+1;
    if (currentShip == 9) {
        shipIndex = 0;
    }
    while ([_unplacedShips[shipIndex] isEqualToString:@"nil"]) {
        if (shipIndex == 9) {
            shipIndex = 0;
        }
        else {
            shipIndex++;
        }
    }
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:_unplacedShips[shipIndex]];
    ship.name = [NSString stringWithFormat:@"%i", index];
    ship.xScale = _fleetBackground.frame.size.width/24/ship.frame.size.width;
    ship.yScale = _fleetBackground.frame.size.width/24/ship.frame.size.height * [sizes[shipIndex]intValue];
    ship.position = CGPointMake(CGRectGetMinX(_fleetBackground.frame) + (7.5 + index)*ship.frame.size.width, [sizes[shipIndex]intValue] * _fleetBackground.frame.size.width/24 - ship.frame.size.height/2 + _fleetBackground.frame.size.height/10);
    [self addChild:ship];
    _placedShip[index] = [NSNumber numberWithInt:shipIndex];
    _unplacedShips[shipIndex] = @"nil";
}
@end