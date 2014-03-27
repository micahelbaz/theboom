//
//  MainGameController.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "MiniMap.h"
#import "Ships.h"
#import "Background.h"
#import "DestroyedShips.h"
#import "Foreground.h"
#import "VisualBar.h"
#import "Helpers.h"
#import "BattleshipGame.h"
#import "Gestures.h"
#import "Console.h"
@interface MainGameController : NSObject

@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Containers *containers;
@property (strong, nonatomic) MiniMap *miniMap;
@property (strong, nonatomic) Ships *ships;
@property (strong, nonatomic) Background *background;
@property (strong, nonatomic) DestroyedShips *destroyedShips;
@property (strong, nonatomic) Foreground *foreground;
@property (strong, nonatomic) VisualBar *visualBar;
@property (strong, nonatomic) Helpers *helper;
@property (strong, nonatomic) Gestures *gestures;
@property (strong, nonatomic) Console *console;

- (instancetype) initMainGameControllerWithGame:(BattleshipGame*)game
                                       andFrame:(CGSize)frame;

@end
