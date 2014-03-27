//
//  Gestures.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-09.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Constants.h"
#import "Helpers.h"
#import "BattleshipGame.h"

@interface Gestures : NSObject

// Max x and max y
@property CGFloat initialMaxX;
@property CGFloat initialMaxY;
@property CGFloat newMaxX;
@property CGFloat newMaxY;
// X and X difference
@property CGFloat differenceX;
@property CGFloat differenceY;

@property Boolean initiallyTouched;

// The Visual Bar container
@property (strong, nonatomic) SKNode *gesturesNode;
@property (strong, nonatomic) BattleshipGame *game;
@property (strong, nonatomic) Helpers *helper;

- (instancetype) initGesturesWithNode:(SKNode*) gesturesNode
                              andGame:(BattleshipGame*) game
                            andHelper:(Helpers*) helper;

- (void) updateGesturesPositionWithTranslation:(CGPoint)translation;
- (void) handlePinchWithRecognizerScale:(CGFloat) scale;

@end
