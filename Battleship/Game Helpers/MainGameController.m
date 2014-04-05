//
//  MainGameController.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "MainGameController.h"

@implementation MainGameController

- (instancetype) initMainGameControllerWithGame:(BattleshipGame*)game
                                       andFrame:(CGSize)frame{
    self = [super init];
    if (self) {
        _game = game;
        _containers = [[Containers alloc] initContainers];
        _helper = [[Helpers alloc] init];
        _console = [[Console alloc] initConsole];
        _background = [[Background alloc] initBackgroundWithNode:_containers.backgroundNode
                                                         andGame:_game];
       // _miniMap= [[MiniMap alloc] initMiniMapWithNode:_containers.miniMapNode
                                               //andGame:_game];
        _foreground = [[Foreground alloc] initForegroundWithNode:_containers.foregroundNode
                                                         andGame:_game
                                                       andHelper:_helper
                                                      andConsole:_console];
        _visualBar = [[VisualBar alloc] initVisualBarWithNode:_containers.visualBarNode
                                                      andGame:_game
                                                andForeground:_foreground
                                                    andHelper:_helper];
        _ships = [[Ships alloc] initShipsWithNode:_containers.activeShipsNode
                                          andGame:_game
                                        andHelper:_helper
                                     andVisualBar:_visualBar
                                    andForeground:_foreground
                                       andMiniMap:_miniMap
                                       andConsole:_console];
        _gestures = [[Gestures alloc] initGesturesWithNode:_containers.gesturesNode
                                                   andGame:_game
                                                 andHelper:_helper];
        
    }
    return self;
}

-(void)redrawShip{
    
}

@end
