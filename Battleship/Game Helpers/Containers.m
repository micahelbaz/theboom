//
//  Containers.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Containers.h"

@implementation Containers

- (instancetype) initContainers{
    self = [super init];
    if (self) {
        [self initContainer];
    }
    return self;
}

// Initializes the subcontainers of the overall screen node
- (void) initContainer{
    
    _overallNode = [[SKNode alloc] init];
    _gesturesNode = [[SKNode alloc] init];
    _backgroundNode = [[SKNode alloc] init];
    _visualBarNode = [[SKNode alloc] init];
    _foregroundNode = [[SKNode alloc] init];
    _activeShipsNode = [[SKNode alloc] init];
    _destroyedShipsNode = [[SKNode alloc] init];
    _miniMapNode = [[SKNode alloc] init];
    
    _overallNode.name = overallNodeName;
    _gesturesNode.name = gesturesNodeName;
    _backgroundNode.name = backgroundNodeName;
    _visualBarNode.name = visualBarNodeName;
    _foregroundNode.name = foregroundNodeName;
    _activeShipsNode.name = activeShipsNodeName;
    _destroyedShipsNode.name = destroyedShipsNodeName;
    _miniMapNode.name = miniMapNodeName;
    
    [_gesturesNode addChild:_backgroundNode];
    [_gesturesNode addChild:_activeShipsNode];
    [_gesturesNode addChild:_foregroundNode];
    [_overallNode addChild:_gesturesNode];
    [_overallNode addChild:_visualBarNode];
    [_overallNode addChild:_destroyedShipsNode];
    [_overallNode addChild:_miniMapNode];
    
}
@end
