//
//  Containers.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@interface Containers : NSObject

// The sprite containers
@property (strong, nonatomic) SKNode *overallNode;
@property (strong, nonatomic) SKNode *gesturesNode;
@property (strong, nonatomic) SKNode *backgroundNode;
@property (strong, nonatomic) SKNode *visualBarNode;
@property (strong, nonatomic) SKNode *foregroundNode;
@property (strong, nonatomic) SKNode *activeShipsNode;
@property (strong, nonatomic) SKNode *destroyedShipsNode;
@property (strong, nonatomic) SKNode *miniMapNode;

// Methods
- (instancetype) initContainers;

@end
