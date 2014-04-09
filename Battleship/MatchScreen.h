//
//  MatchScreen.h
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "GCHelper.h"
#import "BattleshipGame.h"
@interface MatchScreen : SKScene <GKMatchDelegate>

@property (strong, nonatomic) UIViewController* parentView;
@property (nonatomic, strong) BattleshipGame *game;
@property BOOL opponentTouched;
@end

