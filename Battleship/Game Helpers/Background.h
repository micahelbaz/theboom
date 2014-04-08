//
//  Background.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Containers.h"
#import "Constants.h"
#import "BattleshipGame.h"

@interface Background : NSObject

// The Background container
@property (strong, nonatomic) SKNode *backgroundNode;
@property (strong, nonatomic) BattleshipGame *game;


- (instancetype) initBackgroundWithNode:(SKNode*) backgroundNode
                                andGame:(BattleshipGame*) game;
-(void) addMine:(Coordinate *) mineLocation;
- (void) scrollBackgrounds;
-(void) removeBaseFromScreen: (int) xCoord and:(int) yCoord;
@end
